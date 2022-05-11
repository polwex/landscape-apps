import React from 'react';

interface IconButtonProps {
  icon: React.ReactElement;
  action: () => void;
  label: string;
  showTooltip?: boolean;
}

export default function IconButton({
  icon,
  action,
  label,
  showTooltip,
}: IconButtonProps) {
  return (
    <div className="group-two relative cursor-pointer">
      {showTooltip ? (
        <div className="z-2 pointer-events-none absolute -top-10 grid grid-cols-1 grid-rows-2 justify-items-center rounded opacity-0 group-two-hover:opacity-100">
          <div className="hidden w-fit cursor-none rounded bg-gray-400 px-4 py-2 group-two-hover:block">
            <label className="whitespace-nowrap font-semibold text-white">
              {label}
            </label>
          </div>
          <div>
            <svg
              width="17"
              height="8"
              viewBox="0 0 17 8"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                d="M16.5 0L0.5 0L7.08579 6.58579C7.86684 7.36684 9.13316 7.36684 9.91421 6.58579L16.5 0Z"
                fill="#999999"
              />
            </svg>
          </div>
        </div>
      ) : null}
      <button
        className="align-center flex h-8 w-8 rounded p-2 group-two-hover:bg-gray-50"
        onClick={action}
        aria-label={label}
      >
        {icon}
      </button>
    </div>
  );
}