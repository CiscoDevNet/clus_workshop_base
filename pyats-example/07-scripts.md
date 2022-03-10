# Your first pyATS scripts

Let's take what you have learned in the previous sections and apply it to write some re-usable scripts. **During these exercises**, try not to think of this as a strict guide but rather **a tool** to help you get thinking about your own solutions and your own scripts that you can write.

## Write your first script: Up Interfaces

**First thing first** - What's the *task* and what do you want to *accomplish* with this script? You want to know what interfaces are configured `up` and then print out a list of those interfaces.

Now that you know your task, let's get setup. Create a new file under `/home/developer/src` by clicking on the `+` button next to the `src` folder in the editor panel at the top right of your screen. Name the file `up_interfaces.py` and once created, open it in the editor by clicking on it.

![refresh](images/new_file.png)

Good. Now, what's the first thing you need to do to interact with your devices? To interact with your device(s) you need to connect to them. Most scripts will begin with logic similar to below.

You can copy following code blocks into the `up_interfaces.py` file by clicking on the button on the right side of the code block.

Load the testbed file.

```python
from genie.testbed import load
testbed = load('working-tb.yaml')
   ```

Get the device(s) and connect to them.

```python
device = testbed.devices['nx-osv-1']
device.connect()
```

Now that you've connected to the device(s), you need to gather information about all the interfaces. Since the scenario is all about automation, it's best to gather structured data. You can do this with the `parse()` API.

So let's parse `show interface` and save the structure to a variable called `parsed_output` so you can use it later.

```python
parsed_output = device.parse('show interface')
```

The `parsed_output` looks similar to this.

```
{
    'Ethernet4/45': {'admin_state': 'up', <--- This key
                     'auto_mdix': 'off',
                     'auto_negotiate': False,
                     'bandwidth': 1000000,
                     'beacon': 'off',
                     'counters': {'in_bad_etype_drop': 0,
                                  'in_broadcast_pkts': 0,
                                  'in_crc_errors': 0,
                                  'in_discard': 0,
                                  'in_errors': 0,
    (snip)
}
```

To know which interfaces are configured `up`, you can refer to the value of `admin_state`. If the value is `up`, then you will print out a message letting us know.

```python
for interface in parsed_output:
    state = parsed_output[interface]['admin_state']

    if state == 'up':
        print('Interface {intf} is {state}'.format(intf=interface, state=state))
```

Let's save the script and give it a run to test it out.

```bash
cd /home/developer/src

python up_interfaces.py
```

That's it! Easy as pie.

## Second script - CRC errors

Let's create a second script to help get your thoughts flowing. CRC errors are easy to keep track of, but it helps to catch them early. **Take a minute** using the knowledge gained from the previous script and picture the flow of a script that can be used to print out any CRC errors.

Again, create a new file under `/home/developer/src` by clicking on the `+` button next to the `src` folder in the editor panel at the top right of your screen. Name the file `crc_interfaces.py` and once created, open it in the editor by clicking on it.

Okay so you are setup and ready to write your script, **what do you need to do first?** I'll give you a hint, you need to interact with your devices to get information from them.

* Load the testbed file
* Get the device(s) and connect to them

```python
from genie.testbed import load
testbed = load('working-tb.yaml')

device = testbed.devices['nx-osv-1']
device.connect()

```

Get the parsed output from the device.

```python
parsed_output = device.parse('show interface')

```

The `parsed_output` looks similar to this.

```
{
    'Ethernet4/45': {'admin_state': 'up',
                     'auto_mdix': 'off',
                     'auto_negotiate': False,
                     'bandwidth': 1000000,
                     'beacon': 'off',
                     'counters': {'in_bad_etype_drop': 0,
                                  'in_broadcast_pkts': 0,
                                  'in_crc_errors': 0, # <--- This key
                                  'in_discard': 0,
                                  'in_errors': 0,
    # (snip)
}
```

Now collect the required data. This example uses `<dict>.get()` to prevent a KeyError getting raised in the event that the key does not exist.

```python
for interface in parsed_output:
    crc_error = parsed_output[interface].get('counters', {}).get('in_crc_errors')

    if crc_error and crc_error > 0:
        print('Interface {intf} has crc_error of value {crc_error}'.format(intf=interface, crc_error=crc_error))

```

Run the script.

```bash
cd /home/developer/src

python crc_interfaces.py
```

Now you can quickly see which interface has CRC errors.
