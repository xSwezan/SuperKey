local Util = {}

function Util:IsEnum(Value: EnumItem, Category: EnumItem): boolean
	return ({pcall(function()
		return Category[Value.Name]
	end)})[1]
end

return Util