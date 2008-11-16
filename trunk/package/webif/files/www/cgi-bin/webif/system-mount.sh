#!/usr/bin/webif-page
<?
. /usr/lib/webif/webif.sh
###################################################################
# Mount points
#
# Description:
#		Mountpoints
#			Add mount points to fstab 
#
# Author(s) [in order of work date]:
#       m4rc0 <jansssenmaj@gmail.com>
#
# Major revisions:
#		2008-11-12	Initial release
#		2008-11-15  Made editable
#
# NVRAM variables referenced:
#       none
#
# Configuration files referenced:
#		/etc/config/fstab
#
# Required components:
# 


header "System" "Mountpoints" "@TR<<Mountpoints>>" '' "$SCRIPT_NAME"

# Add new mountpint
if ! empty "$FORM_target"; then
	uci_add "fstab" "mount" ""; mountpoint="$CONFIG_SECTION"
	uci_set "fstab" "$mountpoint" "target" "$FORM_target"
	uci_set "fstab" "$mountpoint" "device" "$FORM_device"
	uci_set "fstab" "$mountpoint" "fstype" "$FORM_fstype"
	uci_set "fstab" "$mountpoint" "options" "$FORM_options"
	uci_set "fstab" "$mountpoint" "enabled" "$FORM_enabled"
	FORM_target=""
fi

# Remove selected mountpoint
if ! empty "$FORM_remove_mountpoint"; then
	uci_remove "fstab" "$FORM_remove_mountpoint"
fi


config_cb() {
	local cfg_type="$1"
	local cfg_name="$2"

	case "$cfg_type" in
	        mount)
	                append MOUNTPOINTS "$cfg_name"
	        ;;
	        swap)
	                append SWAP "$cfg_name"
	        ;;	esac
}

# change rowcolors
get_tr() {
	if equal "$cur_color" "odd"; then
		cur_color="even"
		tr="<tr>"
	else
		cur_color="odd"
		tr="<tr class=\"odd\">"
	fi
}


cat <<EOF

<script type="text/javascript" language="JavaScript"><!--
 
var cX = 0; var cY = 0; var rX = 0; var rY = 0; var MountPoint = ''; var SwapMountPoint = ''; ConfigChanged = false;

function UpdateCursorPosition(e){ cX = e.pageX; cY = e.pageY;}
function UpdateCursorPositionDocAll(e){ cX = event.clientX; cY = event.clientY;}

if(document.all) { document.onmousemove = UpdateCursorPositionDocAll; }
else { document.onmousemove = UpdateCursorPosition; }

function AssignPosition(d) {
if(self.pageYOffset) {
	rX = self.pageXOffset;
	rY = self.pageYOffset;
	}
else if(document.documentElement && document.documentElement.scrollTop) {
	rX = document.documentElement.scrollLeft;
	rY = document.documentElement.scrollTop;
	}
else if(document.body) {
	rX = document.body.scrollLeft;
	rY = document.body.scrollTop;
	}
if(document.all) {
	cX += rX; 
	cY += rY;
	}

d.style.left = (cX-150) + "px";
d.style.top = (cY-230) + "px";

}

function HideContent(d,doAction) {
if(d.length < 1) { return; }
document.getElementById(d).style.display = "none";

if (doAction == 'update' && ConfigChanged == true ){

	document.getElementById('TARGET_'+MountPoint).value = document.getElementById('txtTarget').value;
	document.getElementById('DEVICE_'+MountPoint).value = document.getElementById('txtDevice').value;
	document.getElementById('FSTYPE_'+MountPoint).value = document.getElementById('txtFStype').value;
	document.getElementById('OPTIONS_'+MountPoint).value = document.getElementById('txtOptions').value;
	document.getElementById('ENABLED_'+MountPoint).value = document.getElementById('txtEnabled').value;
	document.getElementById('WarningConfigChange').style.display = "block";
	}

if (doAction == 'add'){
	
	document.location.href='/cgi-bin/webif/system-mount.sh?target='+escape(document.getElementById('txtTarget').value)+'&device='+escape(document.getElementById('txtDevice').value)+'&fstype='+escape(document.getElementById('txtFStype').value)+'&options='+escape(document.getElementById('txtOptions').value)+'&enabled='+escape(document.getElementById('txtEnabled').value);
	
	}

}


function replaceAll(text, strA, strB)
{
    while ( text.indexOf(strA) != -1)
    {
        text = text.replace(strA,strB);
    }
    return text;
}


function RemoveMount(mountpoint) {
	document.location.href='/cgi-bin/webif/system-mount.sh?remove_mountpoint='+mountpoint;
	}

function OpenEditWindow(d,TARGET,DEVICE,FSTYPE,OPTIONS,ENABLED,MOUNTPOINT) {
if(d.length < 1) { return; }

OPTIONS = replaceAll(OPTIONS, "%22" , "\\"" );

if ( MOUNTPOINT == 'newMount' ){
	document.getElementById('txtTarget').value = document.getElementById('TARGET_newMount').value;
	document.getElementById('txtDevice').value = document.getElementById('DEVICE_newMount').value;
	document.getElementById('txtFStype').value = document.getElementById('FSTYPE_newMount').value;
	document.getElementById('txtOptions').value = document.getElementById('OPTIONS_newMount').value;
	document.getElementById('txtEnabled').value = document.getElementById('ENABLED_newMount').value;

	document.getElementById('EditWindowAdd').style.display = "block";
	document.getElementById('EditWindowUpdate').style.display = "none";
	}

	else{
	document.getElementById('txtTarget').value = TARGET;
	document.getElementById('txtDevice').value = DEVICE;
	document.getElementById('txtFStype').value = FSTYPE;
	document.getElementById('txtOptions').value = OPTIONS;
	document.getElementById('txtEnabled').value = ENABLED;

	document.getElementById('EditWindowAdd').style.display = "none";
	document.getElementById('EditWindowUpdate').style.display = "block";
	}

var dd = document.getElementById(d);
AssignPosition(dd);
dd.style.display = "block";

MountPoint = MOUNTPOINT;
}

function OpenEditSwapWindow(d,DEVICE,ENABLED,SWAP) {
if(d.length < 1) { return; }

document.getElementById('txtDeviceSwap').value = DEVICE;
document.getElementById('txtEnabledSwap').value = ENABLED;

var dd = document.getElementById(d);
AssignPosition(dd);
dd.style.display = "block";

SwapMountPoint = SWAP;

}

function HideContentSwap(d,doAction) {
if(d.length < 1) { return; }
document.getElementById(d).style.display = "none";

if (doAction == 'update' && ConfigChanged == true ){

	document.getElementById('DEVICESWAP_'+SwapMountPoint).value = document.getElementById('txtDeviceSwap').value;
	document.getElementById('ENABLEDSWAP_'+SwapMountPoint).value = document.getElementById('txtEnabledSwap').value;
	document.getElementById('WarningConfigChange').style.display = "block";
	}


	
}
function SetConfigChanged() {
	
	ConfigChanged = true;
	
	}

//--></script>
EOF

# floating div for editing the mountpoints
echo "<div id=\"EditWindow\" style=\"display:none;position:absolute;border-style: solid;background-color: white;padding: 5px;\">"
echo "<table style=\"text-align: left; font-size: 0.8em;\" border=\"0\" cellpadding=\"2\" cellspacing=\"1\" summary=\"@TR<<Mountpoints>>\">"
echo "<tr><td width=\"100\"><strong>Target</strong></td><td colspan=\"2\"><input type=\"text\" id=\"txtTarget\" name=\"txtTarget\" value=\"\" onChange=\"SetConfigChanged()\" /></td></tr>"
echo "<tr><td width=\"100\"><strong>Device</strong></td><td colspan=\"2\"><input type=\"text\" id=\"txtDevice\" name=\"txtDevice\" value=\"\" onChange=\"SetConfigChanged()\" /></td></tr>"
echo "<tr><td width=\"100\"><strong>FStype</strong></td><td colspan=\"2\"><input type=\"text\" id=\"txtFStype\" name=\"txtFStype\" value=\"\" onChange=\"SetConfigChanged()\" /></td></tr>"
echo "<tr><td width=\"100\"><strong>Options</strong></td><td colspan=\"2\"><input type=\"text\" id=\"txtOptions\" name=\"txtOptions\" value=\"\" onChange=\"SetConfigChanged()\" /></td></tr>"
echo "<tr><td width=\"100\"><strong>Enabled</strong></td><td colspan=\"2\"><input type=\"text\" id=\"txtEnabled\" name=\"txtEnabled\" value=\"\" onChange=\"SetConfigChanged()\" /></td></tr>"
echo "<tr>"
echo "<td colspan=\"2\"><div id=\"EditWindowAdd\" style=\"display:none;\"><a href=\"javascript:HideContent('EditWindow','add')\">@TR<<Add>></a></div>"
echo "<div id=\"EditWindowUpdate\" style=\"display:none;\"><a href=\"javascript:HideContent('EditWindow','update')\">@TR<<Update>></a></div></td>"
echo "<td><a href=\"javascript:HideContent('EditWindow','cancel')\">@TR<<Cancel>></a></td>"
echo "</tr>"
echo "</table>"
echo "</div>"

# floating div for editing swap
echo "<div id=\"EditSwapWindow\" style=\"display:none;position:absolute;border-style: solid;background-color: white;padding: 5px;\">"
echo "<table style=\"text-align: left; font-size: 0.8em;\" border=\"0\" cellpadding=\"2\" cellspacing=\"1\" summary=\"@TR<<swap>>\">"
echo "<tr><td width=\"100\"><strong>Device</strong></td><td colspan=\"2\"><input type=\"text\" id=\"txtDeviceSwap\" name=\"txtDeviceSwap\" value=\"\" onChange=\"SetConfigChanged()\" /></td></tr>"
echo "<tr><td width=\"100\"><strong>Enabled</strong></td><td colspan=\"2\"><input type=\"text\" id=\"txtEnabledSwap\" name=\"txtEnabledSwap\" value=\"\" onChange=\"SetConfigChanged()\" /></td></tr>"
echo "<tr>"
echo "<td colspan=\"2\"><a href=\"javascript:HideContentSwap('EditSwapWindow','update')\">@TR<<Update>></a></td>"
echo "<td><a href=\"javascript:HideContentSwap('EditSwapWindow','cancel')\">@TR<<Cancel>></a></td>"
echo "</tr>"
echo "</table>"
echo "</div>"

uci_load fstab

cur_color="odd"
echo "<h3><strong>@TR<<Mountpoint configurations>></strong></h3>"
echo "<div id=\"WarningConfigChange\" style=\"left:600px;top:0px;display:none;position:absolute;border-style: solid;background-color: white;padding: 5px;\"><img width=\"17\" src=\"/images/warning.png\" alt=\"Configuration changed\" /> Configuration changed. Press 'Save Changes'</div>"
echo "<table style=\"width: 90%; margin-left: 2.5em; text-align: left; font-size: 0.8em;\" border=\"0\" cellpadding=\"2\" cellspacing=\"1\" summary=\"@TR<<Mountpoints>>\">"
for mountpoint in $MOUNTPOINTS; do

	if  [ "$FORM_submit" = "" ]; then
		config_get FORM_TARGET $mountpoint target
		config_get FORM_DEVICE $mountpoint device
		config_get FORM_FSTYPE $mountpoint fstype
		config_get FORM_OPTIONS $mountpoint options
		config_get FORM_ENABLED $mountpoint enabled
	else
		
		eval FORM_TARGET="\$FORM_TARGET_${mountpoint}"
		eval FORM_DEVICE="\$FORM_DEVICE_${mountpoint}"
		eval FORM_FSTYPE="\$FORM_FSTYPE_${mountpoint}"
		eval FORM_OPTIONS="\$FORM_OPTIONS_${mountpoint}"
		eval FORM_ENABLED="\$FORM_ENABLED_${mountpoint}"
	
		if [ "$FORM_TARGET" != "" ]; then
			uci_set fstab $mountpoint "target" $FORM_TARGET
			uci_set fstab $mountpoint "device" $FORM_DEVICE
			uci_set fstab $mountpoint "fstype" $FORM_FSTYPE
			uci_set fstab $mountpoint "options" $FORM_OPTIONS
			uci_set fstab $mountpoint "enabled" $FORM_ENABLED
		else
			config_get FORM_TARGET $mountpoint target
			config_get FORM_DEVICE $mountpoint device
			config_get FORM_FSTYPE $mountpoint fstype
			config_get FORM_OPTIONS $mountpoint options
			config_get FORM_ENABLED $mountpoint enabled

		fi
	fi

	#check if mountpoint is enabled
	if [ "$FORM_ENABLED" == "1" ]; then
		ENABLEDIMAGE="<img width=\"17\" src=\"/images/service_enabled.png\" alt=\"Mountpoint Enabled\" />"
	else
		ENABLEDIMAGE="<img width=\"17\" src=\"/images/service_disabled.png\" alt=\"Mountpoint Disabled\" />"
	fi
	
	#                  1              23                                       4567
	# de '\\\\\\\' --> \ = escape SH, \\ becomes \ which will escape CAT, last: \\\\ om java te escapen om \\ te krijgen
	FORM_escOPTIONS=`echo "$FORM_OPTIONS" | sed -e 's/"/%22/g' | sed -e 's/\\\/\\\\\\\/g'` 

	get_tr
	echo $tr"<td width=\"35\" align=\"center\" valign=\"middle\" rowspan=\"5\">$ENABLEDIMAGE</td><td width=\"100\"><strong>Target</strong></td><td>$FORM_TARGET</td><td width=\"35\" align=\"center\" valign=\"middle\" rowspan=\"5\"><a href=\"javascript:OpenEditWindow('EditWindow','$FORM_TARGET','$FORM_DEVICE','$FORM_FSTYPE','$FORM_escOPTIONS','$FORM_ENABLED','$mountpoint')\">@TR<<edit>></a></td><td width=\"35\" align=\"center\" valign=\"middle\" rowspan=\"5\"><a href=\"javascript:RemoveMount('$mountpoint')\">@TR<<remove>></a></td></tr>"
	echo $tr"<td width=\"100\"><strong>Device</strong></td><td>$FORM_DEVICE</td></tr>"
	echo $tr"<td width=\"100\"><strong>FStype</strong></td><td>$FORM_FSTYPE</td></tr>"
	echo $tr"<td width=\"100\"><strong>Options</strong></td><td>$FORM_OPTIONS</td></tr>"
	echo $tr"<td width=\"100\"><strong>Enabled</strong></td><td>$FORM_ENABLED</td></tr>"
	echo "<tr><td colspan=\"5\"><img alt=\"\" height=\"5\" width=\"1\" src=\"/images/pixel.gif\" /></td></tr>"
done

echo "<tr><td colspan=\"3\">&nbsp;</td><td>&nbsp;</td><td align=\"center\"><a href=\"javascript:OpenEditWindow('EditWindow','','','','','','newMount')\">@TR<<add>></a></td></tr>"

echo "</table><br />"

for mountpoint in $MOUNTPOINTS; do
	echo "<input id=\"TARGET_$mountpoint\" type=\"hidden\" name=\"TARGET_$mountpoint\" value=\"\" />"
	echo "<input id=\"DEVICE_$mountpoint\" type=\"hidden\" name=\"DEVICE_$mountpoint\" value=\"\" />"
	echo "<input id=\"FSTYPE_$mountpoint\" type=\"hidden\" name=\"FSTYPE_$mountpoint\" value=\"\" />"
	echo "<input id=\"OPTIONS_$mountpoint\" type=\"hidden\" name=\"OPTIONS_$mountpoint\" value=\"\" />"
	echo "<input id=\"ENABLED_$mountpoint\" type=\"hidden\" name=\"ENABLED_$mountpoint\" value=\"\" />"
done

echo "<input id=\"TARGET_newMount\" type=\"hidden\" name=\"TARGET_newMount\" value=\"\" />"
echo "<input id=\"DEVICE_newMount\" type=\"hidden\" name=\"DEVICE_newMount\" value=\"\" />"
echo "<input id=\"FSTYPE_newMount\" type=\"hidden\" name=\"FSTYPE_newMount\" value=\"\" />"
echo "<input id=\"OPTIONS_newMount\" type=\"hidden\" name=\"OPTIONS_newMount\" value=\"\" />"
echo "<input id=\"ENABLED_newMount\" type=\"hidden\" name=\"ENABLED_newMount\" value=\"\" />"


cur_color="odd"
echo "<h3><strong>@TR<<Swap configuration>></strong></h3>"
echo "<table style=\"width: 90%; margin-left: 2.5em; text-align: left; font-size: 0.8em;\" border=\"0\" cellpadding=\"2\" cellspacing=\"1\" summary=\"@TR<<Swap>>\">"
for swap in $SWAP; do

	if  [ "$FORM_submit" = "" ]; then 
		config_get FORM_DEVICESWAP $swap device
		config_get FORM_ENABLEDSWAP $swap enabled
	else
		eval FORM_DEVICESWAP="\$FORM_DEVICESWAP_${swap}"
		eval FORM_ENABLEDSWAP="\$FORM_ENABLEDSWAP_${swap}"
		
		if [ "$FORM_DEVICESWAP" != "" ]; then
			uci_set fstab $swap "device" $FORM_DEVICESWAP
			uci_set fstab $swap "enabled" $FORM_ENABLEDSWAP
		else
			config_get FORM_DEVICESWAP $swap device
			config_get FORM_ENABLEDSWAP $swap enabled
		fi
	fi
		
		
	#check if swap is enabled
	if [ "$FORM_ENABLEDSWAP" == "1" ]; then
		ENABLEDIMAGE="<img width=\"17\" src=\"/images/service_enabled.png\" alt=\"Swap Enabled\" />"
	else
		ENABLEDIMAGE="<img width=\"17\" src=\"/images/service_disabled.png\" alt=\"Swap Disabled\" />"
	fi

	get_tr
	echo $tr"<td width=\"35\" align=\"center\" valign=\"middle\" rowspan=\"2\">$ENABLEDIMAGE</td><td width=\"100\"><strong>Device</strong></td><td>$FORM_DEVICESWAP</td><td width=\"35\" align=\"center\" valign=\"middle\" rowspan=\"5\"><a href=\"javascript:OpenEditSwapWindow('EditSwapWindow','$FORM_DEVICESWAP','$FORM_ENABLEDSWAP','$swap')\">@TR<<edit>></a></td></tr>"
	echo $tr"<td width=\"100\"><strong>Enabled</strong></td><td>$FORM_ENABLEDSWAP</td></tr>"
	echo "<tr><td colspan=\"3\"><img alt=\"\" height=\"5\" width=\"1\" src=\"/images/pixel.gif\" /></td></tr>"
done
echo "</table>"

for swap in $SWAP; do
	echo "<input id=\"DEVICESWAP_$swap\" type=\"hidden\" name=\"DEVICESWAP_$swap\" value=\"\" />"
	echo "<input id=\"ENABLEDSWAP_$swap\" type=\"hidden\" name=\"ENABLEDSWAP_$swap\" value=\"\" />"
done


footer ?>
<!--
##WEBIF:name:System:330:Mountpoints
-->