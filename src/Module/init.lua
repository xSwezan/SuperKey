local Types = require(script.Types)

local BindingClass = require(script.Binding)

local SuperKey = {}

function SuperKey:CreateBinding(Key: Types.KeyType): Types.Binding
	local Binding = BindingClass.new(Key)

	return Binding
end

return SuperKey