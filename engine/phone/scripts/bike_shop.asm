BikeShopPhoneCallerScript:
	checkitem SKATEBOARD
	iftrue .Skateboard
	farwritetext BikeShopBicycleCallText
	sjump .Finish

.Skateboard:
	farwritetext BikeShopSkateboardCallText

.Finish:
	clearflag ENGINE_BIKE_SHOP_CALL_ENABLED
	specialphonecall SPECIALCALL_NONE
	end
