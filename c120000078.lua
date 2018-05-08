--DDD超死偉王ホワイテスト・ヘル・アーマゲドン
function c120000078.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf),aux.NonTuner(Card.IsSetCard,0x10af),1)
	--synchro indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SYNCHRO))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--synchro cannot be target
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--cannot be negate/disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_INACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c120000078.effectfilter)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(120000078,0))
	e7:SetCategory(CATEGORY_DISABLE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c120000078.discon)
	e7:SetTarget(c120000078.distg)
	e7:SetOperation(c120000078.disop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c120000078.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:IsActiveType(TYPE_MONSTER) and bit.band(loc,LOCATION_ONFIELD)~=0
end
function c120000078.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:GetFirst()~=c and c:GetLocation()~=LOCATION_PZONE
end
function c120000078.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c120000078.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000078.filter,tp,0,LOCATION_ONFIELD,1,nil,tp) end
end
function c120000078.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsDisabled()
end
function c120000078.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(72402069,2))
	local pc=Duel.SelectMatchingCard(1-tp,c120000078.filter,tp,0,LOCATION_ONFIELD,1,1,nil,tp):GetFirst()
	if not pc then return end
	local g=Duel.GetMatchingGroup(c120000078.tgfilter,tp,0,LOCATION_ONFIELD,pc)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(120000078,RESET_EVENT+0x1fe0000,0,0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetLabelObject(e2)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e4)
		end
		tc=g:GetNext()
		--reset
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(120000078,1))
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_SUMMON_SUCCESS)
		e5:SetLabelObject(e3)
		e5:SetRange(LOCATION_MZONE)
		e5:SetOperation(c120000078.resetop)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetDescription(aux.Stringid(120000078,1))
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_SPSUMMON_SUCCESS)
		e6:SetLabelObject(e5)
		e6:SetRange(LOCATION_MZONE)
		e6:SetOperation(c120000078.resetop2)
		e6:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e6)
	end
end
function c120000078.resetop(e,tp,eg,ep,ev,re,r,rp)
	local e2=e:GetLabelObject()
	local e3=e2:GetLabelObject()
	e2:Reset()
	e3:Reset()
	e:Reset()
end
function c120000078.resetop2(e,tp,eg,ep,ev,re,r,rp)
	local e2=e:GetLabelObject()
	local e3=e2:GetLabelObject()
	local e6=e3:GetLabelObject()
	e2:Reset()
	e3:Reset()
	e6:Reset(nil)
	e:Reset()
end