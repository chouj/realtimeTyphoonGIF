# Auto post GIF of  Typhoon at the Western Pacific by crawling NOAA's Storm Floaters

# 自动推送西太已命名台风的动图链接

## Note

+ Noncommercial use only.

+ windows code.

+ A little modification is needed if you want to run it at ThingSpeak.com

## Mannual

After set your private parameter like IFTTT key in noaafloater.m, using Timer to ensure Schedule Command Execution.

```
cd {the fold path of noaafloater.m}

tc = timer                                 ...
(   'Name'          , 'Typhoon'        ...
,   'TimerFcn'      , @(varargin)evalin('base','noaafloater')  ...
,   'BusyMode'      , 'drop'            ...
,   'ExecutionMode' , 'fixedRate'      ...
,   'Period'        ,  21600               ...
,   'StartDelay'    ,  0                ...
);
start(tc)
```

## Thanks to 

[NOAA storm floaters](http://www.ssd.noaa.gov/PS/TROP/floaters.html)

# demo

Telegram Channel: Satellite Observations (Asia-Pacific) [@ObsAP](https://t.me/ObsAP)
