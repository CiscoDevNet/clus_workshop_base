# Devices

> *Note:* pyATS currently supports a large number of platforms (See [Supported Platforms](https://pubhub.devnetcloud.com/media/unicon/docs/user_guide/supported_platforms.html) for an up-to-date list).

Devices must be defined in what you call the **testbed yaml file**. A testbed yaml file contains all the information regarding your testbed such as the device(s) name, OS, platform, connection information, credentials, and more.

The following example is a testbed yaml file that contains one device.

```yaml
devices:
    csr1000v-1:
        type: router
        os: iosxe
        credentials:
            default:
                password: cisco123
                username: admin
            enable:
                password: cisco123
        connections:
            cli:
                protocol: ssh
                ip: 192.168.1.1
```

>*Note:*  The device name in the testbed yaml file must match the configured hostname of the device. This is the #1 "gotcha"s with connecting to a device. Alternatively you can use the [learn hostname](https://pubhub.devnetcloud.com/media/unicon/docs/user_guide/connection.html?highlight=learn_hostname#customizing-your-connection) feature which will learn the hostname during the initial connection.
>
> "There's two kinds of people using PyATS. Those who have been bit by the case sensitive hostname issue, and those who WILL get bit by the case sensitive hostname issue." - Jeremy Bresley

## Mock devices

Today for the lab, you will use "mock devices" instead of real devices. Mock devices are Python scripts that are used to simulate devices. You can think of them as real devices, though they are limited to a **pre-defined set of show commands** and cannot be configured.

They are very handy for demos, as they will never crash and cause issues. Let's start with the basics.

## Using a mock device

To launch your mock NXOS device, execute the following command.

```bash
cd /home/developer/src

mock_device_cli --os nxos \
                --mock_data_dir mock_devices/working/nxos \
                --state execute
```

In the terminal on the right of this lab, you can see that you launched an NXOS mock device.

This device has numerous pre-defined commands ready for you to experiment with. Execute the following command to see a list of available commands.

```bash
?
```

Finally, execute of few of the available commands to familiarize yourself with mock device interactions.

```bash
show vlan
```

```bash
show vrf
```

```bash
show ip ospf interface vrf all
```

You can see that it feels just like a real device!

**Before moving on, click on the terminal to bring it into focus, then press ``CTRL+C`` to exit the mock device shell.**
