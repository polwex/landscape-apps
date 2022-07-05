import { unstable_batchedUpdates as batchUpdates } from 'react-dom';
import create from 'zustand';
import produce from 'immer';
import { useParams } from 'react-router';
import { useCallback, useMemo } from 'react';
import {
  Gangs,
  Channel,
  Group,
  GroupDiff,
  Groups,
  GroupAction,
  GroupPreview,
} from '../../types/groups';
import api from '../../api';
import groupsReducer from './groupsReducer';
import { GroupState } from './type';

export const GROUP_ADMIN = 'admin';

function groupAction(flag: string, diff: GroupDiff) {
  return {
    app: 'groups',
    mark: 'group-action',
    json: {
      flag,
      update: {
        time: '',
        diff,
      },
    },
  };
}

function subscribeOnce<T>(app: string, path: string) {
  return new Promise<T>((resolve) => {
    api.subscribe({
      app,
      path,
      event: resolve,
    });
  });
}

export const useGroupState = create<GroupState>((set, get) => ({
  groups: {},
  pinnedGroups: [],
  gangs: {},
  pinGroup: async (flag) => {
    await api.poke({
      app: 'groups',
      mark: 'group-remark-action',
      json: {
        flag,
        diff: { pinned: true },
      },
    });
  },
  unpinGroup: async (flag) => {
    await api.poke({
      app: 'groups',
      mark: 'group-remark-action',
      json: {
        flag,
        diff: { pinned: false },
      },
    });
  },
  banShips: async (flag, ships) => {
    await api.poke(
      groupAction(flag, {
        cordon: {
          open: {
            'add-ships': ships,
          },
        },
      })
    );
  },
  unbanShips: async (flag, ships) => {
    await api.poke(
      groupAction(flag, {
        cordon: {
          open: {
            'del-ships': ships,
          },
        },
      })
    );
  },
  banRanks: async (flag, ranks) => {
    await api.poke(
      groupAction(flag, {
        cordon: {
          open: {
            'add-ranks': ranks,
          },
        },
      })
    );
  },
  unbanRanks: async (flag, ranks) => {
    await api.poke(
      groupAction(flag, {
        cordon: {
          open: {
            'del-ranks': ranks,
          },
        },
      })
    );
  },
  search: async (flag) => {
    try {
      const res = await subscribeOnce<GroupPreview>(
        'groups',
        `/gangs/${flag}/preview`
      );
      get().batchSet((draft) => {
        const gang = draft.gangs[flag] || {
          preview: null,
          invite: null,
          claim: null,
        };
        gang.preview = res;
        draft.gangs[flag] = gang;
      });
    } catch (e) {
      // TODO: fix error handling
      console.error(e);
    }
  },
  create: async (req) => {
    await api.poke({
      app: 'groups',
      mark: 'group-create',
      json: req,
    });
  },
  join: async (flag, joinAll) => {
    api.poke({
      app: 'groups',
      mark: 'group-join',
      json: {
        flag,
        'join-all': joinAll,
      },
    });
  },
  // addMember: async
  addSects: async (flag, ship, sects) => {
    const diff = {
      fleet: {
        ships: [ship],
        diff: {
          'add-sects': sects,
        },
      },
    };
    await api.poke(groupAction(flag, diff));
  },
  delSects: async (flag, ship, sects) => {
    const diff = {
      fleet: {
        ships: [ship],
        diff: {
          'del-sects': sects,
        },
      },
    };
    await api.poke(groupAction(flag, diff));
  },
  addMembers: async (flag, ships) => {
    const diff = {
      fleet: {
        ships,
        diff: {
          add: null,
        },
      },
    };
    await api.poke(groupAction(flag, diff));
  },
  delMembers: async (flag, ships) => {
    const diff = {
      fleet: {
        ships,
        diff: {
          del: null,
        },
      },
    };
    await api.poke(groupAction(flag, diff));
  },
  addRole: async (flag, sect, meta) => {
    const diff = {
      cabal: {
        sect,
        diff: {
          add: { ...meta, image: '', color: '' },
        },
      },
    };
    await api.poke(groupAction(flag, diff));
  },
  delRole: async (flag, sect) => {
    const diff = {
      cabal: {
        sect,
        diff: { del: null },
      },
    };
    await api.poke(groupAction(flag, diff));
  },
  start: async () => {
    const [groups, gangs] = await Promise.all([
      api.scry<Groups>({
        app: 'groups',
        path: '/groups',
      }),
      api.scry<Gangs>({
        app: 'groups',
        path: '/gangs',
      }),
    ]);

    try {
      const pinnedGroups = await api.scry<string[]>({
        app: 'groups',
        path: '/groups/pinned',
      });
      get().batchSet((draft) => {
        draft.pinnedGroups = pinnedGroups;
      });
    } catch (error) {
      console.log(error);
    }

    set((s) => ({
      ...s,
      groups,
      gangs,
    }));
    await api.subscribe({
      app: 'groups',
      path: '/groups/ui',
      event: (data) => {
        const { flag, update } = data as GroupAction;
        if ('create' in update.diff) {
          const group = update.diff.create;
          get().batchSet((draft) => {
            draft.groups[flag] = group;
          });
        }
      },
    });
  },
  initialize: async (flag: string) =>
    api.subscribe({
      app: 'groups',
      path: `/groups/${flag}/ui`,
      event: (data) => get().batchSet(groupsReducer(flag, data)),
    }),
  set: (fn) => {
    set(produce(get(), fn));
  },
  batchSet: (fn) => {
    batchUpdates(() => {
      get().set(fn);
    });
  },
}));

export function useGroup(flag: string): Group | undefined {
  return useGroupState(useCallback((s) => s.groups[flag], [flag]));
}

export function useRouteGroup() {
  const { ship, name } = useParams();
  return useMemo(() => `${ship}/${name}`, [ship, name]);
}

const selList = (s: GroupState) => Object.keys(s.groups);
export function useGroupList(): string[] {
  return useGroupState(selList);
}

export function useVessel(flag: string, ship: string) {
  return useGroupState(
    useCallback((s) => s.groups[flag].fleet[ship], [ship, flag])
  );
}

const defGang = {
  invite: null,
  claim: null,
  preview: null,
};

export function useGang(flag: string) {
  return useGroupState(useCallback((s) => s.gangs[flag] || defGang, [flag]));
}

const selGangList = (s: GroupState) => Object.keys(s.gangs);
export function useGangList() {
  return useGroupState(selGangList);
}

export function useChannel(flag: string, channel: string): Channel | undefined {
  return useGroupState(
    useCallback((s) => s.groups[flag]?.channels[channel], [flag, channel])
  );
}

export function usePinnedGroups() {
  return useGroupState(useCallback((s: GroupState) => s.pinnedGroups, []));
}

export function useAmAdmin(flag: string) {
  const group = useGroup(flag);
  const vessel = group?.fleet[window.our];
  return vessel && vessel.sects.includes(GROUP_ADMIN);
}