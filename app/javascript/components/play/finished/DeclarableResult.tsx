import React from 'react'

import { declarableName } from '../../../utils'

import { DeclarableResultType, GamePlayerType } from '../../../types'

export interface Props {
  players: Array<GamePlayerType>
  result: DeclarableResultType
}

const Finished = ({ result }: Props): React.ReactElement => {
  const { slug, made, gamePlayers } = result
  return (
    <div className="">
      {declarableName(slug)} {made ? 'made' : 'off'}
      {gamePlayers.map(({ points, name }) => (
        <div>
          `${name} ${points > 0 ? 'wins' : 'loses'} {Math.abs(points)}`
        </div>
      ))}
    </div>
  )
}

export default Finished
