if not lib then return end

-- Module is deprecated and provided for compatibility
-- All interface functions are provided by w_lib.

exports('Keyboard', lib.inputDialog)

exports('Progress', function(options, completed)
	local success = lib.progressBar(options)

	if completed then
		completed(not success)
	end
end)

exports('CancelProgress', lib.cancelProgress)
exports('ProgressActive', lib.progressActive)
