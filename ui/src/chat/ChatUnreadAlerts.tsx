import { format, isToday } from 'date-fns';
import React, { useCallback } from 'react';
import { pluralize } from '../logic/utils';
import { useChatState } from '../state/chat';
import { ChatBrief } from '../types/chat';

interface ChatUnreadAlertsProps {
  whom: string;
  brief: ChatBrief;
}

export default function ChatUnreadAlerts({
  brief,
  whom,
}: ChatUnreadAlertsProps) {
  const date = brief ? new Date(brief.last) : new Date();
  const since = isToday(date)
    ? `${format(date, 'HH:mm')} today`
    : format(date, 'LLLL d');

  const unreadMessage =
    brief &&
    `${brief.count} new ${pluralize('message', brief.count)} since ${since}`;

  const markRead = useCallback(() => {
    useChatState.getState().markRead(whom);
  }, [whom]);

  if (!brief || brief?.count === 0) {
    return null;
  }

  return (
    <>
      <div className="absolute top-2 left-1/2 z-20 flex w-full -translate-x-1/2 flex-wrap items-center justify-center gap-2">
        <button className="button whitespace-nowrap bg-blue-soft text-sm text-blue lg:text-base">
          <span className="whitespace-nowrap font-normal">{unreadMessage}</span>
          &nbsp;&bull;&nbsp;View Unread
        </button>
        <button
          className="button whitespace-nowrap bg-blue-soft text-sm text-blue lg:text-base"
          onClick={markRead}
        >
          Mark as Read
        </button>
      </div>
      <div />
    </>
  );
}