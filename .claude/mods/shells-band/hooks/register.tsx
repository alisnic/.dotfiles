import { atom, read, update } from 'claude-code'
import type { BuiltinToolResults, Register } from 'claude-code'

import type { Shell } from '../types'

const shells = atom({ plugin: 'shells-band', key: 'shells' } as const, [])

const POLL_MS = 3000

export const register: Register = on => {
  // A Bash call that goes to the background (run_in_background, ctrl+b, timeout) starts a shell.
  // The model's text of the call names the file the shell writes its output to.
  on('tool.call', { tool: 'Bash' }, async ($, e, next) => {
    const ran = await next(e)
    const id = (ran.result as BuiltinToolResults['Bash'] | undefined)?.backgroundTaskId
    const output = ran.text?.match(/(\/\S+\.output)\b/)?.[1]

    if (id && output) {
      await update($, shells, list => [...list, { id, command: e.command, output }])
    }

    return ran
  })

  // A shell ended when no process holds its output file open. This sees every way a shell ends:
  // it finished, Claude stopped it, or the person stopped it in the shells menu.
  on('session.start', async ($, e, next) => {
    $.clock.every(POLL_MS, async () => {
      const list: Shell[] = await read($, shells)

      if (list.length === 0) return

      const ended = new Set<string>()

      await Promise.all(
        list.map(async shell => {
          // lsof exits 1 when no process holds the file. A shell kept from an older version has no file.
          const { exitCode } = await $.process.run(['lsof', '-t', shell.output]).catch(() => ({ exitCode: 1 }))

          if (exitCode !== 0) ended.add(shell.id)
        }),
      )

      if (ended.size > 0) {
        await update($, shells, list => list.filter(shell => !ended.has(shell.id)))
      }
    })

    return next(e)
  })

  // Under the hint line, the last rows of the screen.
  on('ui.render', { component: 'PromptHint' }, async ($, e, next) => {
    const list: Shell[] = await read($, shells)

    if (list.length === 0) {
      return next(e)
    }

    const { Box, Text } = $.ui.resolve(e)

    return (
      <Box flexDirection="column">
        {await next(e)}
        {list.map(shell => (
          // Keep the end of a long command: it usually tells the shells apart.
          <Box key={shell.id} flexDirection="row">
            <Text dimColor>{'>_ '}</Text>
            <Text dimColor wrap="truncate-start">
              {shell.command.replace(/\s+/g, ' ')}
            </Text>
          </Box>
        ))}
      </Box>
    )
  })
}
