--The func function is what is executed upon the commannd being entered. 
--First Param is the Name, second is input

minetest.register_chatcommand("registerGroup", {
	params = "<Group Name>",
	description = "Create a Citatest Group",
	func = function(owner, param)
		local tempName1 = string.lower(param)
		local groupAmount = #groups + 1
		for k, v in pairs(groups) do
			local tempName2 = string.lower(groups[k].name)
			if tempName2 == tempName1 then
				minetest.chat_send_all("Group " .. param .. " already exists!")
				return 0
			end
		end
		
		if param:match("%s") then
			minetest.chat_send_player(owner, "Names may not contain spaces!")
			return 0
		end
		
		groups[groupAmount] = Group.new()
		groups[groupAmount].name = param
		groups[groupAmount].owner = owner
		minetest.chat_send_all("Player " .. owner .. " made the group " .. param .. "!")
		groups[groupAmount]:addmember(owner)
	end
})

minetest.register_chatcommand("transferOwnership", {
	params = "<Group Name> <New Owner>",
	description = "Transfer Ownership of a Citatest Group",
	func = function(user, param)
		local i
		local found, _, groupName, newOwner = param:find("^([^%s]+)([^%s]+)%s+(.+)$")
		if not found then return end

		i = getGroup(groupName)
		if i == "NH" then
			minetest.chat_send_all("Group " .. groupName .. " does not exist!")
			return 0
		end

		if groups[i].owner == user then
			groups[i]:addmember(newOwner)
			groups[i].owner = newOwner
			minetest.chat_send_all("Group " .. groups[i].name .." was transfered to Player " .. newOwner)
		else
			minetest.chat_send_all("Player " .. user .. " tried to change the owner of " .. groups[i].name  .. "!")
		end
	end
})

minetest.register_chatcommand("addMember", {
	params = "<Group name> <Member Name>",
	description = "Add a member to a specified group",
	func = function(name, param)
		local i
		local memberValue
		local found, _, groupName, player = param:find("^([^%s]+)%s+(.+)$")
		if not found then return end
		i = getGroup(groupName)
		if i == "NH" then 
			minetest.chat_send_all("Group " .. groupName .. " does not exist!")
			return 0
		end
		memberValue = groups[i]:checkMember(name)
		if memberValue == true then
			memberValue = groups[i]:checkMember(player)
			if memberValue == false then
				groups[i]:addmember(player)
				minetest.chat_send_all("Player " .. player .. " was added to group " .. groupName)
			else
				minetest.chat_send_all("Player " .. player .. " is already a member")
			end
		else
			minetest.chat_send_all("Player " .. player .. " tried to add a member to a group he/she is not apart of!")
		end
	end
})

minetest.register_chatcommand("removeMember", {
	params = "<Group Name> <Member Name>",
	decription = "Remove a member from a specified group",
	func = function(name, param)
		local i
		local memberValue
		local found, _, groupName, player = param:find("^([^%s]+)%s+(.+)$")
		if not found then return end
		
		i = getGroup(groupName)
		if i == "NH" then
			minetest.chat_send_all("Group " .. groupName .. " does not exist!")
			return 0
		end

		memberValue = groups[i]:checkMember(name)
		if memberValue == true then
			memberValue = groups[i]:checkMember(player)
			if memberValue == true then
				groups[i]:removeMember(player)
				minetest.chat_send_all("Player " .. player .. " was successfully removed from group " .. groupName)
			else
				minetest.chat_send_all("Player " .. player .. " is not a member")
			end
		else
			minetest.chat_send_all("Player " .. player .. " tried to add a member to a group he/she is not apart of!")
		end
	end
})

minetest.register_chatcommand("disbandGroup", {
	params = "<Group Name> <Reason>",
	description = "Disband a Group you own.",
	func = function(user, param)
		local groupValue
		local memberValue
		local found, _, groupName, reason = param:find("^([^%s]+)%s+(.+)$")
		if not found then return end
		groupValue = getGroup(groupName)
		if groupValue == false then
			minetest.chat_send_all("Group " .. groupName .. " does not exist!")
			return 0
		end
		
		memberValue = groups[groupValue]:checkMember(user)
		if memberValue == true then
			if groups[groupValue].owner == user then
				minetest.chat_send_all("Group " .. groupName .. " was disbanded by " .. user .. " because: " .. reason)
				table.remove(groups, groupValue)
			else
				minetest.chat_send_all("Player " .. user .. " tried to illegally disband group " .. groupName .. "!")
			end
		else
			minetest.chat_send_all("Player " .. user .. " tried to illegally disband group " .. groupName .. "!")
		end
	end
})

minetest.register_chatcommand("renameGroup", {
	params = "<Group Name> <New Name>",
	description = "Rename a group you own.",
	func = function(user, param)
		local groupValue
		local memberValue
		local found, _, oldGroupName, newName = param:find("^([^%s]+)%s+(.+)$")
		if not found then return end
		groupValue = getGroup(OldGroupName)
		if groupValue == false then
			minetest.chat_send_all("Group " .. oldGroupName .. " does not exist!")
			return 0
		end
		
		memberValue = groups[groupValue]:checkMember(user)
		if memberValue == true then
			if groups[groupValue].owner == user then
				groups[groupValue].name = newName
				minetest.chat_sen_all("Group " .. oldGroupName .. " was renamed too " .. newName .. "!")
			else
				minetest.chat_send_all("Player " .. user .. " tried to illegally rename group " .. oldGroupName .. "!")
			end
		else
			minetest.chat_send_all("Player " .. user .. " tried to illegally rename group " .. oldGroupName .. "!")
		end
	end
})

minetest.register_chatcommand("splitGroup", {
	params = "<Original Group Name> <New Group Name>",
	description = "This allows any user to split a group from an original one.",
	func = function(user, param)
		local groupValue
		local memberValue
		local found, _, oldGroup, splitGroup = param:find("^([^%s]+)%s+(.+)$")
		if not found then return end
		
		groupValue = getGroup(OldGroup)			
		if groupValue == false then
			minetest.chat_send_all("Group " .. oldGroup .. " does not exist!")
			return 0
		end
		
		memberValue = groups[groupValue]:checkMember(user)
		if memberValue == true then
		
			for k, v in pairs(groups) do
				local tempName2 = string.lower(groups[k].name)
				print(tempName2 .."k")
				if tempName2 == tempName1 then
					minetest.chat_send_all("Group " .. param .. " already exists!")
					return 0
				end
			end

			groups[groupAmount] = makeNewGroup()
			groups[groupAmount].name = param
			groups[groupAmount].owner = user
			minetest.chat_send_all("Group " .. newGroup .. " was split from " .. oldGroup .. "!")
			groups[groupAmount]:addMember(user)
		else
			minetest.chat_send_all("Player " .. user .. " tried to illegally split from group " .. oldGroupName .. "!")
		end
	end
})

minetest.register_chatcommand("announce", {
	params = "<Group Name> <Message>",
	description = "Announce something to all members of the group.",
	func = function(user, param)
		local groupNumber 
		local isMember
		local found, _, groupName, message = param:find("^([^%s]+)%s+(.+)$")
		if not found then return end
		
		groupNumber = getGroup(groupName)
		if groupNumber == false then
			minetest.chat_send_all("Group " .. groupName .. " does not exist!")
			return 0
		end
		
		isMember = groups[groupNumber]:checkMember(user)
		if isMember == true then
			if groups[groupNumber].owner == user then
				for k, v in pairs(groups[groupNumber].members) do
					minetest.chat_send_player(groups[groupNumber].members[k], message)
				end
			else
				local player = minetest.get_player_by_name(user)
				minetest.chat_send_player(player, "You don't have the permissions to do that!")
			end
		else
			minetest.chat_send_player(player, "You aren't even a member of that group!")
		end
	end
})
