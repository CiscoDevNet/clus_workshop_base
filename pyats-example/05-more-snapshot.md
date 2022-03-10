# Snapshot a single command

Previously, you took a snapshot with the `models` object. If you only require a snapshot from one or two `show` commands instead of an entire model, you can do the same thing.

View the list of [existing parsers](https://pubhub.devnetcloud.com/media/genie-feature-browser/docs/#/parsers) to find the `show` command that you want to use. There are a few thousand different parsers currently, with more being added each month.

Take the initial snapshot of the `show` command with the `pyats parse` command.

```bash
cd /home/developer/src

pyats parse "show interface" \
            --testbed-file working-tb.yaml \
            --output initial_interface_snapshot \
            --device nx-osv-1
```

Later take another snapshot of the same `show` command.

```bash
cd /home/developer/src

pyats parse "show interface" \
            --testbed-file broken-tb.yaml \
            --output second_interface_snapshot \
            --device nx-osv-1
```
> *Note:* To simulate a network change on your mock devices, you are using a different testbed file than in the initial snapshot.

And finally, compare the two snapshots using the `pyats diff` command.

```bash
cd /home/developer/src

pyats diff initial_interface_snapshot second_interface_snapshot \
           --output diff_show_interface
```

This will generate `/home/developer/src/diff_show_interface/diff_nx-osv-1_show-interface_parsed.txt`, which will tell you that the interface Ethernet2/1 has been shutdown.

## Creating a testbed file

Now you will create your own Testbed file so you can start performing the same actions on your own network.

You guessed it: you have a pyATS command to help you out.

```bash
pyats create testbed interactive --output my_own_testbed.yaml
```

This command walks you through how to create your own testbed file. For this demo, you can put random information.

The testbed file can also be created manually following [the schema](https://pubhub.devnetcloud.com/media/pyats/docs/topology/schema.html) and [example](https://pubhub.devnetcloud.com/media/pyats/docs/topology/example.html).
