local UserInputService = game:GetService("UserInputService")
local Types = require(script.Parent.Types)
local Janitor = require(script.Parent.Parent.Janitor)

local KeyClass = require(script.Parent.Key)

local Binding = {}
Binding.__index = Binding

function Binding.new(Key: Types.KeyType): Types.Binding
	local self = setmetatable({},Binding)

	self.__Janitor = Janitor.new()

	self:__NewEvent("InputDown")
	self:__NewEvent("InputUp")

	local Keys: {Types.Key} = {}

	for Index, Key: Types.KeyType in if (typeof(Key) == "table") then Key else {Key} do
		local NewKey: Types.Key = KeyClass.new(Key)
		self.__Janitor:Add(NewKey.InputDown:Connect(function()
			if (self.__IsDown) then return end

			self.__IsDown = Index
			self:__FireEvent("InputDown")
		end))
		self.__Janitor:Add(NewKey.InputUp:Connect(function()
			if (self.__IsDown ~= Index) then return end

			self.__IsDown = nil
			self:__FireEvent("InputUp")
		end))
		table.insert(Keys, NewKey)
	end

	print(Keys)
	
	self.Keys = Keys

	return self
end

function Binding:__NewEvent(Name: string)
	self.Events = self.Events or {}
	self.Events[Name] = self.__Janitor:Add(Instance.new("BindableEvent"))
	self[Name] = self.Events[Name].Event
end

function Binding:__FireEvent(Name: string, ...)
	if not (self.Events[Name]) then return end

	local Args = {...}
	self.Events[Name]:Fire(unpack(Args))
end

function Binding:IsDown(): boolean
	-- for _, Key: Types.Key in self.Keys do
	-- 	if not (Key:IsDown()) then continue end

	-- 	return true
	-- end
	-- return false
	return (self.__IsDown ~= nil)
end

function Binding:Destroy()
	self.__Janitor:Destroy()
end

return Binding