/* -*- Mode: C++; tab-width: 6 -*- */ 
/**
 *    This file is part of DictatorAI
 *
 *    It's free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    You should have received a copy of the GNU General Public License
 *    with it.  If not, see <http://www.gnu.org/licenses/>.
 *
**/

class AIVehicleTest extends AIInfo 
 {
   function GetAuthor()      { return "Krinn"; }
   function GetName()        { return "AIVehicleTest"; }
   function GetDescription() { return "An ai to see how your AI will see vehicles in game"; }
   function GetVersion()     { return 2; }
   function GetDate()        { return "2011-08-07"; }
   function CreateInstance() { return "AIVehicleTest"; }
   function UseAsRandomAI()  { return false; }
   function GetShortName()   { return "AIVT"; }
   
   function GetSettings() 
   {
     AddSetting({name = "bool_setting",
                 description = "a bool setting, default off", 
                 easy_value = 0, 
                 medium_value = 0, 
                 hard_value = 0, 
                 custom_value = 0, 
                 flags = AICONFIG_BOOLEAN});
                 
     AddSetting({name = "bool2_setting", 
                description = "a bool setting, default on", 
                easy_value = 1, 
                medium_value = 1, 
                hard_value = 1, 
                custom_value = 1, 
                flags = AICONFIG_BOOLEAN});
                
     AddSetting({name = "int_setting", 
                 description = "an int setting", 
                 easy_value = 30, 
                 medium_value = 20, 
                 hard_value = 10, 
                 custom_value = 20, 
                 flags = 0, 
                 min_value = 1, 
                 max_value = 100});    	
   }
 }
 
 RegisterAI(AIVehicleTest());

