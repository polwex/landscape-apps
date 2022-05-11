import { describe, it, expect } from 'vitest';
import React from 'react';
import { render } from '@testing-library/react';
import ChatInput from './ChatInput';

describe('ChatInput', () => {
  it('renders as expected', () => {
    const { asFragment } = render(<ChatInput flag="~zod/test" />);
    expect(asFragment()).toMatchSnapshot();
  });
});