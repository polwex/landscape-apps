import React from 'react';
import _ from 'lodash';
import f from 'lodash/fp';
import { ChatSeal } from '../../types/chat';
import apiContainer from '../../api';

const { api } = apiContainer;

interface ChatReactionProps {
  seal: ChatSeal;
  feel: string;
}

export default function ChatReaction({ seal, feel }: ChatReactionProps) {
  const count = _.flow(
    f.pickBy((fe: string) => fe === feel),
    f.keys
  )(seal.feels).length;

  const addFeel = () => {
    api.poke({
      app: 'chat',
      mark: 'chat-action',
      json: {
        flag: '~zod/test',
        update: {
          time: '',
          diff: {
            'add-feel': {
              feel,
              ship: `~${window.ship}`,
            },
          },
        },
      },
    });
  };
  return (
    <div>
      {count > 0 && (
        <div
          onClick={addFeel}
          className="flex items-center space-x-2 rounded bg-gray-50 px-2 py-1 text-sm font-semibold leading-4 text-gray-600"
        >
          <span>{feel}</span>
          <span>{count}</span>
        </div>
      )}
    </div>
  );
}
