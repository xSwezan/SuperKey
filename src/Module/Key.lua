local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Types = require(script.Parent.Types)
local Janitor = require(ReplicatedStorage.Packages.Janitor)

local Util = require(script.Parent.Util)

local KeyClass = {}
KeyClass.__index = KeyClass

function KeyClass.new(Key: Types.KeyType)
	local self = setmetatable({}, KeyClass)

	self.__Janitor = Janitor.new()

	self.Keys = {Key}

	self:__NewEvent("InputDown")
	self:__NewEvent("InputUp")

	self.__Janitor:Add(UserInputService.InputBegan:Connect(function(Input: InputObject, GP: boolean)
		if (GP) then return end
		if (self:IsAKey(Input.KeyCode)) and not (self.__IsDown) and (self:IsDown()) then
			self.__IsDown = true
			self:__FireEvent("InputDown")
		end
	end))

	self.__Janitor:Add(UserInputService.InputEnded:Connect(function(Input: InputObject, GP: boolean)
		if (GP) then return end
		if (self:IsAKey(Input.KeyCode)) and (self.__IsDown) and not (self:IsDown()) then
			self.__IsDown = false
			self:__FireEvent("InputUp")
		end
	end))

	return self
end

function KeyClass:__NewEvent(Name: string)
	self.Events = self.Events or {}
	self.Events[Name] = self.__Janitor:Add(Instance.new("BindableEvent"))
	self[Name] = self.Events[Name].Event
end

function KeyClass:__FireEvent(Name: string, ...)
	if not (self.Events[Name]) then return end

	local Args = {...}
	self.Events[Name]:Fire(unpack(Args))
end

function KeyClass:IsAKey(KeyToFind: Types.KeyType): boolean?
	local function Search(Keys: {Types.KeyType})
		for _, Key: Types.KeyType in Keys do
			if (Key == KeyToFind) then
				return true
			elseif (typeof(Key) == "table") then
				if (Search(Key)) then return true end
			end
		end
	end

	if (Search(self.Keys)) then
		return true
	end

	return false
end

function KeyClass:IsDown(Keys: {Types.KeyType}?): boolean?
	for _, Key: Types.KeyType in (Keys or self.Keys) do
		if (typeof(Key) == "table") then
			if (self:AreAllDown(Key)) then return true end
		elseif (Util:IsEnum(Key, Enum.KeyCode)) then
			if (UserInputService:IsKeyDown(Key)) then return true end
		end
	end
	return false
end

function KeyClass:AreAllDown(Keys: {Types.KeyType}?): boolean?
	for _, Key: Types.KeyType in (Keys or self.Keys) do
		if (self:IsDown{Key}) then continue end

		return false
	end
	return true
end

return KeyClass