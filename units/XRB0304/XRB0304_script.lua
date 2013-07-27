#****************************************************************************
#**
#**  File     :  /cdimage/units/XRB0304/XRB0304_script.lua
#**  Author(s):  Dru Staltman, Gordon Duclos
#**
#**  Summary  :  Cybran Engineering tower
#**
#**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CConstructionStructureUnit = import('/lua/cybranunits.lua').CConstructionStructureUnit

XRB0304 = Class(CConstructionStructureUnit) 
{
    OnStartBeingBuilt = function(self, builder, layer)
        CConstructionStructureUnit.OnStartBeingBuilt(self, builder, layer)
        self:HideBone('xrb0304', true)
        self:ShowBone('TurretT3', true)
        self:ShowBone('Door3_B03', true)
        self:ShowBone('B03', true)
        self:ShowBone('Attachpoint03', true)
    end,   
    
    OnStartBuild = function(self, unitBeingBuilt, order)
        if self.buildingThread then
            KillThread( self.buildingThread)
        end

        self.buildingThread = self:ForkThread(self.OpenState, unitBeingBuilt, order )

    end,
    
    OnStopBuild = function(self, unitBeingBuilt)
        if self.buildingThread then
            KillThread( self.buildingThread)
        end
        self.buildingThread = self:ForkThread(self.CloseState, unitBeingBuilt)        
    end,

    OpenState = function(self, unitBeingBuilt, order)
            if not self.AnimationManipulator then
                self.AnimationManipulator = CreateAnimator(self)
                self.Trash:Add(self.AnimationManipulator)
            end
            self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationOpen, false):SetRate(1)
            WaitFor(self.AnimationManipulator)
            CConstructionStructureUnit.OnStartBuild(self, unitBeingBuilt, order)
        end,

    CloseState = function(self, unitBeingBuilt)
            if not self.AnimationManipulator then
                self.AnimationManipulator = CreateAnimator(self)
                self.Trash:Add(self.AnimationManipulator)
            end
            self.AnimationManipulator:SetRate(-1)
            WaitFor(self.AnimationManipulator)
            CConstructionStructureUnit.OnStopBuild(self, unitBeingBuilt)
        end,

}
TypeClass = XRB0304