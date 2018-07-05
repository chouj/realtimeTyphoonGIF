%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auto post GIF of Typhoon at the Western Pacific by crawling NOAA's Storm Floaters

% 自动推送西太已命名台风的动图链接

% Note: Noncommercial use only.
%       windows code.

% Thanks to http://www.ssd.noaa.gov/PS/TROP/floaters.html

% demo: https://t.me/ObsAP

% Author: github.com/chouj
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd d:\ % for example, can be modified

pre='http://www.ssd.noaa.gov'; 
url=urlread([pre,'/PS/TROP/floaters.html']);

options = weboptions('RequestMethod','post');

if exist('.\tcarray.mat')==0 
    % tcarray.mat is an string array of typhoon names that have been posted.
    tcarray=''; 
    
    try
        t = regexp(url,'<td width="20%" valign="top">(.*)</td>','tokens');
    catch
        pause(60);
        t = regexp(url,'<td width="20%" valign="top">(.*)</td>','tokens');
    end
    t = t{1};
    
    tc=regexp(t,'<td width="20%" valign="top">(.*?)</td>','tokens');
    tc=tc{1,1}(8); % Western Pacific
    tc=tc{1};
    
    eachtc=regexp(tc,'<center>(.*?)</center>','tokens');
    
    for i=1:length(eachtc{1,1}(:))
        tcindex=[eachtc{1,1}{1,i}];
        tcindex=[tcindex{1}];
        
        url=regexp(tcindex,'<a href="(.*?)" class="Regular_Link"><strong>(.*?)</strong></a>','tokens');
        temp=url{1,1}{1,2}; % get names of tropical cyclones
        
        % Unnamed tropical cyclone has an identification code begins with a number
        if isempty(strfind(temp(1),'0'))&isempty(strfind(temp(1),'1'))&isempty(strfind(temp(1),'2'))...
            &isempty(strfind(temp(1),'3'))&isempty(strfind(temp(1),'4'))&isempty(strfind(temp(1),'5'))...
            &isempty(strfind(temp(1),'6'))&isempty(strfind(temp(1),'7'))&isempty(strfind(temp(1),'8'))...
            &isempty(strfind(temp(1),'9'))
            
            % find the url of GIF
            try
                t = regexp(urlread(url{1,1}{1,1}),'<tr[^>]*>(.*?)</tr>','tokens');
            catch
                pause(60);
                t = regexp(urlread(url{1,1}{1,1}),'<tr[^>]*>(.*?)</tr>','tokens');
            end
            t=cell2mat(t{14});
            t = regexp(t,'<td[^>]*><a href="(.*?)".*?</td>','tokens');
            t = [pre,cell2mat(t{7})];
            
            % post by utilizing IFTTT's webhook
            response = webwrite('https://maker.ifttt.com/trigger/{EventName}/with/key/{YourKEY}', 'value1',t,'value2',temp,options);
            
            % generate tcarray.mat
            tcarray{length(tcarray)+1}=temp;
        end
    end
    save('.\tcarray.mat','tcarray');
    
else

    load .\tcarray.mat

    try
        t = regexp(url,'<td width="20%" valign="top">(.*)</td>','tokens');
    catch
        pause(60);
        t = regexp(url,'<td width="20%" valign="top">(.*)</td>','tokens');
    end
    t = t{1};
    tc=regexp(t,'<td width="20%" valign="top">(.*?)</td>','tokens');
    tc=tc{1,1}(8);tc=tc{1};
    eachtc=regexp(tc,'<center>(.*?)</center>','tokens');
    
    for i=1:length(eachtc{1,1}(:))
        tcindex=[eachtc{1,1}{1,i}];
        tcindex=[tcindex{1}];
        url=regexp(tcindex,'<a href="(.*?)" class="Regular_Link"><strong>(.*?)</strong></a>','tokens');
        temp=url{1,1}{1,2};
        if isempty(strfind(temp(1),'0'))&isempty(strfind(temp(1),'1'))&isempty(strfind(temp(1),'2'))...
                &isempty(strfind(temp(1),'3'))&isempty(strfind(temp(1),'4'))&isempty(strfind(temp(1),'5'))...
                &isempty(strfind(temp(1),'6'))&isempty(strfind(temp(1),'7'))&isempty(strfind(temp(1),'8'))...
                &isempty(strfind(temp(1),'9'))
            if sum(strcmp(tcarray,temp))==0 % whether there is a new named typhoon
                tcarray{length(tcarray)+1}=temp; % store that name in array
                try
                    t = regexp(urlread(url{1,1}{1,1}),'<tr[^>]*>(.*?)</tr>','tokens');
                catch
                    pause(60);
                    t = regexp(urlread(url{1,1}{1,1}),'<tr[^>]*>(.*?)</tr>','tokens');
                end
                t=cell2mat(t{14});
                t = regexp(t,'<td[^>]*><a href="(.*?)".*?</td>','tokens');
                t = [pre,cell2mat(t{7})];

                response = webwrite('https://maker.ifttt.com/trigger/{EventName}/with/key/{YourKEY}', 'value1',t,'value2',temp,options);
                save('.\tcarray.mat','tcarray');
            end
        end
    end
    
end
