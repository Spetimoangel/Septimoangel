--ＤＴ 黒の女神ウィタカ
function c120000107.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c120000107.spcon)
	e1:SetOperation(c120000107.spop)
	c:RegisterEffect(e1)
	--lvchange
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c120000107.lvtg)
	e2:SetOperation(c120000107.lvop)
	c:RegisterEffect(e2)
end
function c120000107.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.CheckLPCost(c:GetControler(),1000)
end
function c120000107.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,1000)
end
function c120000107.lvfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c120000107.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c120000107.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c120000107.lvfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
		and e:GetHandler():GetLevel()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c120000107.lvfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function c120000107.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end	
end
