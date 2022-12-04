local Types = {}

export type KeyType = Enum.KeyCode | {KeyType}

export type Key = {
	IsDown: (self: Key) -> boolean?;
	AreAllDown: (self: Key) -> boolean?;

	InputDown: RBXScriptSignal;
	InputUp: RBXScriptSignal;
}

export type Binding = {
	IsDown: (self: Binding, Key: KeyType) -> boolean;

	InputDown: RBXScriptSignal;
	InputUp: RBXScriptSignal;
}

return Types