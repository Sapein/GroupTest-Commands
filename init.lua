
minetest.register_chatcommand("gtregisterGroup", { 
	params = "<Group Name>",
	description = "Create a GroupTest Group",
	func = function(owner, param)
		local tempName1 = string.lower(param)
		local groupAmount = #gt_groups + 1
		for k, v in pairs(gt_groups) do
			local tempName2 = string.lower(gt_groups[k].name)
			if tempName2 == tempName1 then
				minetest.chat_send_all("Group " .. param .. " already exists!")
				return 0
			end
		end
		
		if param:match("%s") then
			minetest.chat_send_player(owner, "Names may not contain spaces!")
			return 0
		end
		
		gt_groups[groupAmount] = gt_Group.new()
		gt_groups[groupAmount].name = param
		gt_groups[groupAmount].owner = owner
		minetest.chat_send_all("Player " .. owner .. " made the group " .. param .. "!")
		gt_groups[groupAmount]:addmember(owner)
	end
})

minetest.register_chatcommand("gttransferOwnership", {
	params = "<Group Name> <New Owner>",
	description = "Transfer Ownership of a GroupTest Group",
	func = function(user, param)
		local i
		local found, _, groupName, newOwner = param:find("^([^%s]+)([^%s]+)%s+(.+)$")
		if not found then return end

		i = gt_getGroup(groupName)
		if i == "NH" then
			minetest.chat_send_all("Group " .. groupName .. " does not exist!")
			return 0
		end

		if gt_groups[i].owner == user then
			gt_groups[i]:addmember(newOwner)
			gt_groups[i].owner = newOwner
			minetest.chat_send_all("Group " .. gt_groups[i].name .." was transfered to Player " .. newOwner)
		else
			minetest.chat_send_all("Player " .. user .. " tried to change the owner of " .. gt_groups[i].name  .. "!")
		end
	end
})

minetest.register_chatcommand("gtaddMember", {
	params = "<Group name> <Member Name>",
	description = "Add a member to a specified GroupTest group",
	func = function(name, param)
		local i
		local memberValue
		local found, _, groupName, player = param:find("^([^%s]+)%s+(.+)$")
		if not found then return end
		i = gt_getGroup(groupName)
		if i == "NH" then 
			minetest.chat_send_all("Group " .. groupName .. " does not exist!")
			return 0
		end
		memberValue = gt_groups[i]:checkMember(name)
		if memberValue == true then
			memberValue = gt_groups[i]:checkMember(player)
			if memberValue == false then
				gt_groups[i]:addmember(player)
				minetest.chat_send_all("Player " .. player .. " was added to group " .. groupName)
			else
				minetest.chat_send_all("Player " .. player .. " is already a member")
			end
		else
			minetest.chat_send_all("Player " .. player .. " tried to add a member to a group he/she is not apart of!")
		end
	end
})

minetest.register_chatcommand("gtremoveMember", {
	params = "<Group Name> <Member Name>",
	decription = "Remove a member from a specified GroupTest group",
	func = function(name, param)
		local i
		local memberValue
		local found, _, groupName, player = param:find("^([^%s]+)%s+(.+)$")
		if not found then return end
		
		i = gt_getGroup(groupName)
		if i == "NH" then
			minetest.chat_send_all("Group " .. groupName .. " does not exist!")
			return 0
		end

		memberValue = gt_groups[i]:checkMember(name)
		if memberValue == true then
			memberValue = gt_groups[i]:checkMember(player)
			if memberValue == true then
				gt_groups[i]:removeMember(player)
				minetest.chat_send_all("Player " .. player .. " was successfully removed from group " .. groupName)
			else
				minetest.chat_send_all("Player " .. player .. " is not a member")
			end
		else
			minetest.chat_send_all("Player " .. player .. " tried to add a member to a group he/she is not apart of!")
		end
	end
})

minetest.register_chatcommand("gtdisbandGroup", {
	params = "<Group Name> <Reason>",
	description = "Disband a group that you own.",
	func = function(user, param)
		local groupValue
		local memberValue
		local found, _, groupName, reason = param:find("^([^%s]+)%s+(.+)$")
		if not found then return end
		groupValue = gt_getGroup(groupName)
		if groupValue == false then
			minetest.chat_send_all("Group " .. groupName .. " does not exist!")
			return 0
		end
		
		memberValue = gt_groups[groupValue]:checkMember(user)
		if memberValue == true then
			if gt_groups[groupValue].owner == user then
				minetest.chat_send_all("Group " .. groupName .. " was disbanded by " .. user .. " because: " .. reason)
				table.remove(gt_groups, groupValue)
			else
				minetest.chat_send_all("Player " .. user .. " tried to illegally disband group " .. groupName .. "!")
			end
		else
			minetest.chat_send_all("Player " .. user .. " tried to illegally disband group " .. groupName .. "!")
		end
	end
})

minetest.register_chatcommand("gtrenameGroup", {
	params = "<Group Name> <New Name>",
	description = "Rename a group you own.",
	func = function(user, param)
		local groupValue
		local memberValue
		local found, _, oldGroupName, newName = param:find("^([^%s]+)%s+(.+)$")
		if not found then return end
		groupValue = gt_getGroup(OldGroupName)
		if groupValue == false then
			minetest.chat_send_all("Group " .. oldGroupName .. " does not exist!")
			return 0
		end
		
		memberValue = gt_groups[groupValue]:checkMember(user)
		if memberValue == true then
			if gt_groups[groupValue].owner == user then
				gt_groups[groupValue].name = newName
				minetest.chat_sen_all("Group " .. oldGroupName .. " was renamed too " .. newName .. "!")
			else
				minetest.chat_send_all("Player " .. user .. " tried to illegally rename group " .. oldGroupName .. "!")
			end
		else
			minetest.chat_send_all("Player " .. user .. " tried to illegally rename group " .. oldGroupName .. "!")
		end
	end
})

minetest.register_chatcommand("gtsplitGroup", {
	params = "<Original Group Name> <New Group Name>",
	description = "This allows any user to split a group from an original one.",
	func = function(user, param)
		local groupValue
		local memberValue
		local found, _, oldGroup, splitGroup = param:find("^([^%s]+)%s+(.+)$")
		if not found then return end
		
		groupValue = gt_getGroup(OldGroup)			
		if groupValue == false then
			minetest.chat_send_all("Group " .. oldGroup .. " does not exist!")
			return 0
		end
		
		memberValue = gt_groups[groupValue]:checkMember(user)
		if memberValue == true then
		
			for k, v in pairs(gt_groups) do
				local tempName2 = string.lower(gt_groups[k].name)
				print(tempName2 .."k")
				if tempName2 == tempName1 then
					minetest.chat_send_all("Group " .. param .. " already exists!")
					return 0
				end
			end

			gt_groups[groupAmount] = gt_Group.new()
			gt_groups[groupAmount].name = param
			gt_groups[groupAmount].owner = user
			minetest.chat_send_all("Group " .. newGroup .. " was split from " .. oldGroup .. "!")
			gt_groups[groupAmount]:addMember(user)
		else
			minetest.chat_send_all("Player " .. user .. " tried to illegally split from group " .. oldGroupName .. "!")
		end
	end
})

minetest.register_chatcommand("gtannounce", {
	params = "<Group Name> <Message>",
	description = "Announce something to all members of the specified GroupTest Group.",
	func = function(user, param)
		local groupNumber 
		local isMember
		local found, _, groupName, message = param:find("^([^%s]+)%s+(.+)$")
		if not found then return end
		
		groupNumber = gt_getGroup(groupName)
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
