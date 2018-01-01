#pragma semicolon 1

#include <sourcemod>

public Plugin plugin = 
{
	name = "[TF2] Crossbow Headshots",
	author = "2010kohtep",
	description = "Allows medic to do headshots with crossbow.",
	version = "1.0.0",
	url = "https://github.com/2010kohtep"
};

// Return offsetted address
Address GameConfGetAddressEx(Handle h, const char[] patch, const char[] offset)
{
	Address iAddr = GameConfGetAddress(h, patch);
	
	if (iAddr == Address_Null)
	{
		return Address_Null;
	}
	
	int iOffset = GameConfGetOffset(h, offset);
	
	if(iOffset == -1)
	{
		return Address_Null;
	}
	
	iAddr += view_as<Address>(iOffset);
	return iAddr;
}

void WriteData(Address iAddr, int[] Data, int iSize)
{
	if (iAddr == Address_Null)
	{
		return;
	}
	
	for (int i = 0; i < iSize; i++)
	{
		StoreToAddress(iAddr + view_as<Address>(i), Data[i], NumberType_Int8);
	}
}

void Patch_HealingBolt_CanHeadshot()
{
	Handle h = LoadGameConfigFile("tf2.koh.crossbowhs");
	if (h == null)
	{
		SetFailState("Failed to load tf2.koh.crossbowhs gamedata.");
		return;
	}
	
	Address pAddr = GameConfGetAddressEx(h, "Patch_Crossbow_CanHeadshot", "CTFProjectile_HealingBolt::CanHeadshot");
	
	delete h;
	
	if (pAddr == Address_Null)
	{
		LogError("[ERROR] Failed to patch CTFProjectile_HealingBolt::CanHeadshot()");
		return;
	}

	WriteData(pAddr, { 0xB9, 0x01, 0x00, 0x00, 0x00, 0x90, 0x90, 0x90 }, 8);
}

public void OnPluginStart()
{
	Patch_HealingBolt_CanHeadshot();
}