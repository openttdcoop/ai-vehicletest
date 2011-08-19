/* -*- Mode: C++; tab-width: 6 -*- */ 
/**
 *
 *    It's free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    You should have received a copy of the GNU General Public License
 *    with it.  If not, see <http://www.gnu.org/licenses/>.
 *
 *    Authors: Krinn
**/

class AIVehicleTest extends AIController
 {
   worktile = null;
   signhandle= null;
   raillist = null;
   constructor()
   {
   worktile = null;
   signhandle= null;
   raillist = AIList();
   }
 }
 
 
 function AIVehicleTest::Start()
	{
	AILog.Info("AIVehicleTest Started.");
	AILog.Info("Switch to cheat mode, and use the AI player so when you alter a sign, the ai will stay proprietary of the sign.");
	AILog.Info("So you better also cheat to gave money to the AI, else the AI might fail if running short (no account support).");
	AILog.Info("Then change the sign to match the vehicle name (or partial name) the AI need to test, only road/trains/wagons are support for now");
	AILog.Info("If you test a train, AI will also check all wagons that appears compatible against that train to really check they are compatible.");
	AILog.Info("If you test a wagon, AI will also check all wagons that run on the same railtype to show their refit capacity");
  	//set a legal railtype. 
	local types = AIRailTypeList();
	AIRail.SetCurrentRailType(types.Begin());
	AIRoad.SetCurrentRoadType(AIRoad.ROADTYPE_ROAD);
	local worktile=null;
	   while (true)
		{
		if (this.worktile==null)	{ this.Init(); AIController.Sleep(50); }
		this.SignChange();
	     	this.Sleep(20);
		this.Clear();
	  	}
	}

function AIVehicleTest::VehicleTypeToString(vtype)
	{
	switch (vtype)
		{
		case AIVehicle.VT_RAIL:
			return "VT_RAIL";
		case AIVehicle.VT_ROAD:
			return "VT_ROAD";
		case AIVehicle.VT_WATER:
			return "VT_WATER";
		case AIVehicle.VT_AIR:
			return "VT_AIR";
		case AIVehicle.VT_INVALID:
			return "VT_INVALID";
		}
	return "VT_UNKNOW";
	}

function AIVehicleTest::RailTypeCheck()
	{
	if (!this.raillist.IsEmpty())	return;
	for (local i=0; i < 255; i++)	raillist.AddItem(i,0);
	this.raillist.Valuate(AIRail.IsRailTypeAvailable);
	this.raillist.KeepValue(1);
	if (this.raillist.IsEmpty())	AILog.Warn("No railtype found");
	}

function AIVehicleTest::TestRail(engineID)
	{
	this.RailTypeCheck();
	if (this.raillist.IsEmpty())	return;
	foreach (rail, dum in this.raillist)
		{
		AILog.Info("AIEngine.CanRunOnRail  : "+AIEngine.CanRunOnRail(engineID, rail)+" for railtype ID: "+rail);
		AILog.Info("AIEngine.HasPowerOnRail: "+AIEngine.HasPowerOnRail(engineID, rail)+" for railtype ID: "+rail);
		}
	}

function AIVehicleTest::CargoSupportString(acargolist)
	{
	local supportStr="";
	acargolist.KeepValue(1);
	if (acargolist.IsEmpty())	return "nothing";
	foreach (crg, value in acargolist)	supportStr+=AICargo.GetCargoLabel(crg)+"("+crg+") ";
	return supportStr;
	}
	
function AIVehicleTest::RefitAndPull(engineID)
	{
	local cargolist=AICargoList();
	local canpull=AIList();
	local canrefit=AIList();
	foreach (crg, dum in cargolist)
		{
		if (AIEngine.CanRefitCargo(engineID, crg))	canrefit.AddItem(crg, 1);
							else	canrefit.AddItem(crg, 0);
		if (AIEngine.CanPullCargo(engineID, crg))	canpull.AddItem(crg, 1);
							else	canpull.AddItem(crg, 0);
		}
	local canpull_str=this.CargoSupportString(canpull);
	local canrefit_str=this.CargoSupportString(canrefit);
	AILog.Info("AIEngine.CanPullCargo  : "+canpull_str);
	AILog.Info("AIEngine.CanRefitCargo : "+canrefit_str);
	}

function AIVehicleTest::BrowseVehicle()
	{
	local fullList=AIEngineList(AIVehicle.VT_RAIL);
	local vehlist=AIEngineList(AIVehicle.VT_ROAD);
	fullList.AddList(vehlist);
	local engineID=null;
	local vehname=AISign.GetName(this.signhandle);
	if (vehname==null)	return;
	local atest=null;
	foreach (engID, dum in fullList)
		{
		local st=AIEngine.GetName(engID);
		if (st == null) continue;
		if (st.find(vehname) != null)
				{ engineID=engID; break; }
		}
	if (engineID==null)	{ AILog.Info("Cannot find <"+vehname+"> spelling is wrong?"); AISign.SetName(this.signhandle,"X"); return false; }
	AILog.Info("----- Basic infos ------");
	AILog.Info("Engine ID              : "+engineID);
	AILog.Info("AIEngine.GetName       : "+AIEngine.GetName(engineID));
	atest=this.VehicleTypeToString(AIEngine.GetVehicleType(engineID));
	AILog.Info("AIEngine.GetVehicleType: "+AIEngine.GetVehicleType(engineID)+" ("+atest+")");
	AILog.Info("AIEngine.IsValidEngine : "+AIEngine.IsValidEngine(engineID));
	atest=AIEngine.IsBuildable(engineID);
	AILog.Info("AIEngine.IsBuildable   : "+atest);
	AILog.Info("AIEngine.GetDesignDate : "+AIEngine.GetDesignDate(engineID));
	if (!atest)	return false;
	AILog.Info("AIEngine.GetCapacity   : "+AIEngine.GetCapacity(engineID));
	AILog.Info("AIEngine.GetReliabity  : "+AIEngine.GetReliability(engineID));
	AILog.Info("AIEngine.GetMaxSpeed   : "+AIEngine.GetMaxSpeed(engineID));
	AILog.Info("AIEngine.GetPrice      : "+AIEngine.GetPrice(engineID));
	AILog.Info("AIEngine.GetMaxAge     : "+AIEngine.GetMaxAge(engineID));
	AILog.Info("AIEngine.GetRunningCost: "+AIEngine.GetRunningCost(engineID));
	AILog.Info("AIEngine.IsWagon       : "+AIEngine.IsWagon(engineID));
	AILog.Info("AIEngine.IsArticulated : "+AIEngine.IsArticulated(engineID));
	AILog.Info("AIEngine.GetPower      : "+AIEngine.GetPower(engineID));
	AILog.Info("AIEngine.GetWeight     : "+AIEngine.GetWeight(engineID));
	AILog.Info("AIEngine.GetMaxTractiveEffort: "+AIEngine.GetMaxTractiveEffort(engineID));
	this.RefitAndPull(engineID);
	atest=AIEngine.GetVehicleType(engineID);
	if (atest == AIVehicle.VT_RAIL)
		{
		AILog.Info("---------TRAIN-----------");
		this.TestRail(engineID);
		}
	AILog.Info("---------REFIT-----------");
	this.RefitCheck(engineID);
	AISign.SetName(this.signhandle,"X");
	AILog.Info("----------END-----------");
	}

function AIVehicleTest::IsDepotTile()
	{
	if (AIRail.IsRailDepotTile(this.worktile))	return true;
	if (AIRoad.IsRoadDepotTile(this.worktile))	return true;
	return false;
	}

function AIVehicleTest::BuildDepot(road,engineID)
	{
	if (this.IsDepotTile())	AITile.DemolishTile(this.worktile);
	if (road)	return AIRoad.BuildRoadDepot(this.worktile, this.worktile+AIMap.GetTileIndex(0, 1));
		else	{
			foreach (rtype, dum in this.raillist)
				{
				if (AIEngine.CanRunOnRail(engineID,rtype))	{ AIRail.SetCurrentRailType(rtype); break; }
				}
			return AIRail.BuildRailDepot(this.worktile, this.worktile+AIMap.GetTileIndex(0, 1));
			}
	}

function AIVehicleTest::RefitCheck(engineID)
	{
	local isRoad= (AIEngine.GetVehicleType(engineID) == AIVehicle.VT_ROAD);
	local cargolist=AICargoList();
	local atest=null;
	local wagonID=null;
	local vehID=null;
	local isTrain=(!isRoad && !AIEngine.IsWagon(engineID));
	if (!this.BuildDepot(isRoad,engineID))	{ this.SendError(); return; }
	if (isRoad || isTrain)
		{
		vehID=AIVehicle.BuildVehicle(this.worktile, engineID);
		if (!AIVehicle.IsValidVehicle(vehID))	{ this.SendError(); return; }
		local allfail=true;
		foreach (crg, dum in cargolist)
			{
			atest=AIVehicle.GetRefitCapacity(vehID, crg);
			if (atest > 0)	{ allfail=false; AILog.Info("can refit to "+AICargo.GetCargoLabel(crg)+" with a capacity of "+atest); }
			}
		if (allfail)	AILog.Info(AIEngine.GetName(engineID)+" cannot be refit to anything");
		// now check wagons usage against that train (UKRS bug)
		if (isRoad)	{ AIVehicle.SellVehicle(vehID);	return; }
		local wagonlist=AIEngineList(AIVehicle.VT_RAIL);
		wagonlist.Valuate(AIEngine.IsWagon);
		wagonlist.KeepValue(1);
		wagonlist.Valuate(AIEngine.CanRunOnRail,AIRail.GetCurrentRailType());
		wagonlist.KeepValue(1);
		local wagoncheck=AIList();
		foreach (wagon, dum in wagonlist)
			{
			local st="";
			wagonID=AIVehicle.BuildVehicle(this.worktile, wagon);
			st="Wagon "+AIEngine.GetName(wagon)+"("+wagon+") ";
			if (!AIVehicle.IsValidVehicle(wagonID))
				{
				AILog.Info(st+"cannot be built ??? -> "+AIError.GetLastErrorString());
				continue;
				}
			if (AIVehicle.MoveWagon(wagonID,0,vehID,0))
				{
				wagoncheck.AddItem(wagon,1);
				if (!AIVehicle.SellWagon(vehID,1))	this.SendError();
				}
			else	{
				wagoncheck.AddItem(wagon,0);;
				if (!AIVehicle.SellWagon(wagonID,0))	this.SendError();
				}
			//AILog.Info(st);
			}
		AILog.Info("--------USE WAGON--------");
		AILog.Info("Can use wagons  : ");
		foreach (wagonID, valid in wagoncheck)
			{
			if (valid == 1)	AILog.Info(wagonID+" - "+AIEngine.GetName(wagonID));
			}
		AILog.Info("Fail with wagons: ");
		foreach (wagonID, valid in wagoncheck)
			{
			if (valid == 0)	AILog.Info("openttd id="+wagonID+" - "+AIEngine.GetName(wagonID));
			}
		if (!AIVehicle.SellVehicle(vehID))	this.SendError();
		}
	else	{ // we are testing a wagon
		local wagonlist=AIEngineList(AIVehicle.VT_RAIL);
		wagonlist.Valuate(AIEngine.IsWagon);
		wagonlist.KeepValue(1);
		wagonlist.Valuate(AIEngine.CanRunOnRail,AIRail.GetCurrentRailType());
		wagonlist.KeepValue(1);
		local wagoncheck=AIList();
		local cargolist=AICargoList();
		local atest=null;
		local res="";
		local wagonID=null;
		foreach (wagon, dummy in wagonlist)
			{
			res="openttd id="+wagon+" - "+AIEngine.GetName(wagon)+" :";
			local allcrg="";
			local allfail=true;
			wagonID=AIVehicle.BuildVehicle(this.worktile, wagon);
			if (!AIVehicle.IsValidVehicle(wagonID))
				{
				AILog.Info(res+"cannot be built ??? -> "+AIError.GetLastErrorString());
				continue;
				}
			foreach (crg, dum in cargolist)
				{
				atest=AIVehicle.GetRefitCapacity(wagon, crg);
				if (atest > 0)	{ allfail=false; allcrg+=AICargo.GetCargoLabel(crg)+" ("+atest+") "; }
				}
			if (allfail)	allcrg="nothing";
			AILog.Info(res+" "+allcrg+" Length="+AIVehicle.GetLength(wagonID));
			if (!AIVehicle.SellWagon(wagonID,0))	this.SendError();
			}
		}
	}

function AIVehicleTest::SignChange()
	{
	local newvalue=AISign.GetName(this.signhandle);
	if (newvalue != "X")	this.BrowseVehicle();
	}

function AIVehicleTest::SendError()
	{
	AILog.Error(AIError.GetLastErrorString());
	}

function AIVehicleTest::Init()
	{
	local maptile=AITileList();
	local x=AIMap.GetMapSizeX()/2;
	local y=AIMap.GetMapSizeY()/2;
	maptile.AddRectangle(AIMap.GetTileIndex(x-10,y-10), AIMap.GetTileIndex(x+10,y+10));
	maptile.Valuate(AITile.GetSlope);
	maptile.KeepValue(0);
	maptile.Valuate(AITile.IsBuildable);
	maptile.KeepValue(1);
	if (maptile.IsEmpty())
		{
		AILog.Info("Please, make a flat & clear point within area mark with x");
		foreach (tile, dum in maptile)	AISign.BuildSign(tile,"x");
		return false;
		}
	this.Clear();
	this.worktile=maptile.Begin();
	this.signhandle=AISign.BuildSign(this.worktile,"X");
	AILog.Info("Now edit sign X and change it with a vehicle name you wish AI tests run on");
	}

function AIVehicleTest::Clear()
	{
	local signs=AISignList();
	foreach (sign, dum in signs)
		{
		if (AISign.GetLocation(sign)!=this.worktile)	AISign.RemoveSign(sign);
		}
	}
