import React, { useState } from 'react';
import { useNavigate } from 'react-router';
import ob from 'urbit-ob';
import CreatableSelect from 'react-select/creatable';
import {
  components,
  ControlProps,
  OptionProps,
  createFilter,
  MenuProps,
  MenuListProps,
  InputProps,
  MultiValueRemoveProps,
  MultiValueGenericProps,
  MultiValue,
} from 'react-select';
import ChatInput from '../chat/ChatInput/ChatInput';
import Layout from '../components/layout/Layout';
import MagnifyingGlass from '../components/icons/MagnifyingGlass';
import { useContacts } from '../state/contact';
import Avatar from '../components/Avatar';
import ExclamationPoint from '../components/icons/ExclamationPoint';
import XIcon from '../components/icons/XIcon';
import { preSig } from '../logic/utils';

interface Option {
  value: string;
  label: string;
}

function Control({ children, ...props }: ControlProps<Option, true>) {
  return (
    <components.Control
      {...props}
      className="input cursor-text items-center text-gray-800"
    >
      <MagnifyingGlass className="h-6 w-6 text-gray-300" />
      {children}
    </components.Control>
  );
}

function ShipName({ data, ...props }: OptionProps<Option, true>) {
  const { value, label } = data;
  return (
    <components.Option
      data={data}
      className="hover:cursor-pointer hover:bg-gray-50 active:bg-gray-50"
      {...props}
    >
      <div className="flex items-center space-x-1">
        {ob.isValidPatp(preSig(value)) ? (
          <Avatar ship={preSig(value)} size="xs" />
        ) : (
          <div className="h-6 w-6 rounded bg-white" />
        )}
        <span className="font-semibold">{preSig(value)}</span>
        {label ? (
          <span className="font-semibold text-gray-300">{label}</span>
        ) : null}
      </div>
    </components.Option>
  );
}

function NoShipsMessage() {
  return (
    <div className="flex content-center space-x-1 px-2 py-3">
      <ExclamationPoint className="w-[18px] text-gray-300" />
      <span className="italic">This name was not found.</span>
    </div>
  );
}

function AddNonContactShip(value: string) {
  return ob.isValidPatp(preSig(value)) ? null : <NoShipsMessage />;
}

function ShipTagLabelContainer({
  children,
  ...props
}: MultiValueGenericProps<Option, true>) {
  return (
    <components.MultiValueContainer {...props}>
      <div className="flex">{children}</div>
    </components.MultiValueContainer>
  );
}

function ShipTagLabel({ data }: { data: Option }) {
  const { value } = data;
  return (
    <div className="flex h-6 items-center rounded-l bg-gray-100">
      <span className="p-1 font-semibold">{value}</span>
    </div>
  );
}

function ShipTagRemove(props: MultiValueRemoveProps<Option, true>) {
  return (
    <components.MultiValueRemove {...props}>
      <div className="flex h-full items-center rounded-r bg-gray-100 pr-1">
        <XIcon className="h-4 text-gray-300" />
      </div>
    </components.MultiValueRemove>
  );
}

function ShipDropDownMenu({ children, ...props }: MenuProps<Option, true>) {
  return (
    <components.Menu className="rounded-lg border-2 border-gray-100" {...props}>
      {children}
    </components.Menu>
  );
}

function ShipDropDownMenuList({
  children,
  ...props
}: MenuListProps<Option, true>) {
  return (
    <components.MenuList className="rounded-md bg-white" {...props}>
      {children}
    </components.MenuList>
  );
}

function Input({ children, ...props }: InputProps<Option, true>) {
  return (
    <components.Input className="text-gray-800" {...props}>
      {children}
    </components.Input>
  );
}

export default function NewDM() {
  const [ship, setShip] = useState<Option | undefined>();
  const contacts = useContacts();
  const contactNames = Object.keys(contacts);
  const contactOptions = contactNames.map((contact) => ({
    value: contact,
    label: contacts[contact].nickname,
  }));
  const navigate = useNavigate();
  const validShip = ship ? ob.isValidPatp(ship.value) : false;
  const onChange = (inputValue: MultiValue<Option>) => {
    if (inputValue) {
      // We can only set one ship for the time being.
      // For now we'll just take the first ship.
      setShip(inputValue[0]);
    }
  };
  const onKeyDown = (event: React.KeyboardEvent<HTMLDivElement>) => {
    if (event.key === 'Enter' && !!ship && validShip) {
      navigate(`/dm/${ship.value}`);
    }
  };

  const onCreateOption = (inputValue: string) => {
    const siggedInput = preSig(inputValue);
    if (ob.isValidPatp(siggedInput)) {
      setShip({ value: siggedInput, label: siggedInput });
    }
  };

  // const filterConfig = {
  // ignoreCase: true,
  // ignoreAccents: true,
  // trim: true,
  // matchFrom: 'any',
  // };

  return (
    <Layout
      className="flex-1"
      footer={
        <div className="border-t-2 border-black/10 p-4">
          <ChatInput
            whom={ship ? ship.value : ''}
            showReply
            sendDisabled={!validShip}
            newDm
            navigate={navigate}
          />
        </div>
      }
    >
      <div className="w-full py-3 px-4">
        <CreatableSelect
          formatCreateLabel={AddNonContactShip}
          autoFocus
          isMulti
          styles={{
            control: (base) => ({}),
            menu: ({ width, borderRadius, ...base }) => ({
              borderWidth: '',
              borderColor: '',
              backgroundColor: 'inherit',
              ...base,
            }),
            input: (base) => ({
              ...base,
              margin: '',
              color: '',
              paddingTop: '',
              paddingBottom: '',
            }),
            multiValue: (base) => ({
              ...base,
              backgroundColor: '',
              margin: '0 2px',
            }),
            multiValueRemove: (base) => ({
              ...base,
              paddingRight: '',
              paddingLeft: '',
              '&:hover': {
                color: 'inherit',
                backgroundColor: 'inherit',
              },
            }),
            option: (base) => ({
              ...base,
              backgroundColor: '',
              '&:active': {
                backgroundColor: 'inherit',
              },
            }),
            valueContainer: (base) => ({
              ...base,
              padding: '0px 8px',
            }),
          }}
          aria-label="Ships"
          options={contactOptions}
          value={ship}
          onChange={onChange}
          onCreateOption={onCreateOption}
          isValidNewOption={(inputValue) =>
            inputValue ? ob.isValidPatp(preSig(inputValue)) : false
          }
          onKeyDown={onKeyDown}
          placeholder="Type a name ie; ~sampel-palnet"
          hideSelectedOptions
          // TODO: create custom filter for sorting potential DM participants.
          // filterOption={createFilter(filterConfig)}
          components={{
            Control,
            Menu: ShipDropDownMenu,
            MenuList: ShipDropDownMenuList,
            Input,
            DropdownIndicator: () => null,
            IndicatorSeparator: () => null,
            ClearIndicator: () => null,
            Option: ShipName,
            NoOptionsMessage: NoShipsMessage,
            MultiValueLabel: ShipTagLabel,
            MultiValueContainer: ShipTagLabelContainer,
            MultiValueRemove: ShipTagRemove,
          }}
        />
      </div>
    </Layout>
  );
}