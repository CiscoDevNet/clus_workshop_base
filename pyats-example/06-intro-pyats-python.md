# pyATS with Python

So far you have used the CLI to perform all your actions. Now let's jump into Python to see what else you can do with the framework.

Let's visit five of the most common APIs that will help you get started with the automation.

## Loading the testbed

All the network automation with pyATS starts with a testbed yaml file. You must load this file to access and interact with any of the devices.

To start, enter your python shell.

```bash
cd /home/developer/src

python
```

Next, use the Genie testbed loader to load the testbed yaml file. The loader will load the yaml file and initialize all the device objects, connection information, and more. Import the loader and call it with the path to your testbed yaml file and save the result to a variable called `testbed`.

```bash
from genie.testbed import load
testbed = load('working-tb.yaml')
```

Now that you have a testbed object, you are ready to move on!

## Connect

Before interacting with any device you must connect to the them. To do this you have an API called `connect`.

Save your device `nx-osv-1` to a new variable. `testbed.devices` is a dictionary that contains all the devices in the testbed yaml file.

```bash
device = testbed.devices['nx-osv-1']
```

Now let's connect to it:

```bash
device.connect()
```

Great, you are connected! Now the fun begins: you can interact with the device.

## Execute

This is the most basic interaction. It sends commands to the device in enabled mode and then it returns the text that the device returned.

Execute `show version` on your device and save the output to a variable called `output`.

```bash
output = device.execute('show version')
```

Let's see what is inside the output variable and see what you can do with that output.

```bash
print(output)
'7.3' in output
```

You can do some validation. Does `7.3` exists in the output?

```bash
if '7.3' in output:
    print("'7.3' was found in the output!")

```

However, there are some major drawbacks with using the raw device output for automation:

* **It's not an accurate method.** Think about it. If you wanted to verify that the image version was `7.3` and `7.3` was found anywhere else in the output, it would still return True regardless of the image version. Not good.

* **Difficult to collect information.** For example, if you want to know all of the interfaces that are up, you would need to implement your own method to collect the information with certainty.

Don't worry: this is solved with the next API. However these scenarios are something important to think about while writing automation.

More information about `execute` can be found in the [documentation](https://pubhub.devnetcloud.com/media/unicon/docs/user_guide/services/generic_services.html#execute).

## Parser

With pyATS Parsers, the raw output from the device is converted to a structured Python dictionary. Now, you are in business and you can automate! You can retrieve any information you are looking for with certainty, just by querying the dictionary.

Let's build on the `execute` example by parsing `show version`, and then saving it to a variable called `parsed`.

```bash
parsed = device.parse('show version')
```

If you were to print it out right now, it's not in a very human friendly structure, because there is no formatting.

```bash
parsed
```

Let's print that nicely with a package called "pretty print", also known as `pprint`.

```bash
from pprint import pprint
pprint(parsed)
```

Now you can get the exact value that you are looking for. Let's try retrieving some data.

```bash
parsed2 = device.parse('show vrf')

pprint(parsed2)

parsed2['vrfs']['default']['vrf_id']
parsed2['vrfs']['default']['vrf_state']
```

One last example:

```bash
for vrf in parsed2['vrfs']:
    vrf_id = parsed2['vrfs'][vrf]['vrf_id']
    vrf_state = parsed2['vrfs'][vrf]['vrf_state']
    print('Vrf {vrf} is {state}'.format(vrf=vrf_id, state=vrf_state))

```

As you can see, it becomes very easy to navigate the device output and collect the desired information with certainty. Feel free to play with other `show` commands and retrieve different keys.

## Configure

The configure API will enter the `configure terminal`, enter your configuration, then exit the `configuration terminal` back to the `enable mode`. If any configuration command is invalid, the API will raise an exception to notify you.

Let's try configuring interface `ethernet2/1 shutdown`.

```bash
configuration = '''\
interface ethernet2/1
shutdown'''

output = device.configure(configuration)
```

With this, configuration on any device is very easy. The configuration can also be a list of config rather than a string.

```bash
configuration = [
    'interface ethernet2/1',
    'shutdown'
]

output = device.configure(configuration)
```

## Learn

The learn API creates common models of information about a specific feature by using the `genie.libs.ops` module. This module provides a representation of the current operational state of a device, per feature (protocol). It *learns* the operational state by executing a series of commands and parsing the output into a structure that's common across different operating systems. The output is stored with the same key-value pair structure across devices and os.

Let's learn the `interface` feature and take a look at the structure

```bash
output = device.learn('interface')
pprint(output.info)
```

This returns a dictionary which can be manipulated the same as a parser output. The output structure is the same across all operating systems.

All the available models can be seen on your [Genie Feature Browser](https://pubhub.devnetcloud.com/media/genie-feature-browser/docs/#/models).

## Other APIs

There are many of other available APIs. You can find a list of them [here](https://pubhub.devnetcloud.com/media/unicon/docs/user_guide/services/index.html).

> *Note:* These will not work on the mock devices provided, but will work on real devices.

**Before moving on, click on the terminal to bring it into focus, then press ``CTRL+D`` to exit the python shell.**
