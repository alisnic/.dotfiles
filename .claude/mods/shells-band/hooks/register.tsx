import { atom, read, update } from 'claude-code'
import type { BuiltinToolResults, Register } from 'claude-code'

import type { Shell } from '../types'

const shells = atom({ plugin: 'shells-band', key: 'shells' } as const, [])

export const register: Register = on => {
  // A Bash call that goes to the background (run_in_background, ctrl+b, timeout) starts a shell.
  on('tool.call', { tool: 'Bash' }, async ($, e, next) => {
    const ran = await next(e)
    const id = (ran.result as BuiltinToolResults['Bash'] | undefined)?.backgroundTaskId

    if (id) {
      await update($, shells, list => [...list, { id, command: e.command }])
    }

    return ran
  })

  // TaskStop ends a shell.
  on('tool.call', { tool: 'TaskStop' }, async ($, e, next) => {
    const ran = await next(e)
    const id = (ran.result as BuiltinToolResults['TaskStop'] | undefined)?.task_id

    if (id) {
      await update($, shells, list => list.filter(shell => shell.id !== id))
    }

    return ran
  })

  // The task notification of a shell ends it. Each notification starts a model request,
  // so the messages carry it. A render hook cannot write state, so this is not done there.
  // Each step reads only the messages it did not read yet; after a reload it reads them all,
  // so a shell that ended while the mod was not loaded also leaves the list.
  let checked = 0

  on('turn.step', async function* ($, e, next) {
    const list: Shell[] = await read($, shells)

    if (e.agentId === undefined && list.length > 0) {
      const messages = await $.session.messages()
      // A compaction makes the list shorter; then read it all again.
      const unread = JSON.stringify(messages.slice(checked <= messages.length ? checked : 0))
      checked = messages.length

      const ended = new Set([...unread.matchAll(/<task-id>([^<]+)<\/task-id>/g)].map(match => match[1]))

      if (list.some(shell => ended.has(shell.id))) {
        await update($, shells, list => list.filter(shell => !ended.has(shell.id)))
      }
    }

    return yield* next(e)
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
