function [RotorEquivalentWindSpeed] = RotorEquivalentWindSpeed(WindSpeed)

%% Nicht fertig, Daten m�ssen von Lidar kommen

    RotorEquivalentWindSpeed = nthroot(1 / sum(RotorPanelElements) * sum(bsxfun(@times, WindProfile .^ 3, RotorPanelElements)), 3);

end

