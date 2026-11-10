trigger CalAccountCitySyncTrigger on Account (after update) {
    CalAccountCitySync.copyCity(Trigger.new, Trigger.oldMap);
}