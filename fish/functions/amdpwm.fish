function amdpwm --description "Control AMDGPU fan speed through pwm values"
    if test $argv[1] = "auto"
        echo 2 | sudo tee /sys/class/drm/card0/device/hwmon/hwmon0/pwm1_enable
    else if test -n $argv[1]
        echo 1 | sudo tee /sys/class/drm/card0/device/hwmon/hwmon0/pwm1_enable
        echo $argv[1] | sudo tee /sys/class/drm/card0/device/hwmon/hwmon0/pwm1
    else
        echo "Usage: amdpwm [auto|<number>]"
    end
end
