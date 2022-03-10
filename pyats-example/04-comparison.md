# Network comparison

Imagine that the snapshot you just took was a daily snapshot taken of your network. Yesterday's snapshot gives us a baseline on how the network is performing and how you expect tomorrow to be. Today, you want to take another snapshot and then compare the two snapshots to verify that nothing changed.

## New snapshot

Oh no! Disaster has struck! The top-secret network that you are in charge of has suddenly stopped working.

It's okay. Remain calm. Remember, pyATS will help you quickly figure out what happened.

Take a new snapshot and save it to a different folder.

```bash
cd /home/developer/src

pyats learn interface ospf platform \
            --testbed-file broken-tb.yaml \
            --output broken_snapshot
```

> **Note:** To simulate a network change on your mock devices, you are using a different testbed file than in the initial snapshot.

That's it! You have taken the new snapshot of your network for `interface`, `ospf` and `platform`. This generates the same files as the initial snapshot.

You do not want to compare only the text; this is not precise and contains a lot of noise. Instead, you should compare the `<model>_<os>_<device>_ops.txt` files, because they contain parsed outputs.

The pyATS `diff` command compares the files in two different folders and then generates the diff in a new file at the current working directory.

```bash
cd /home/developer/src

pyats diff working_snapshot broken_snapshot \
           --output diff_snapshot
```

> *Note:*  If you do not see two `diff_<model>_<os>_<device>_ops.txt` files in the `/home/developer/src/diff_snapshot` directory, hover over the developer directory and click on the refresh button.
>
>![refresh](images/refresh.png)

Easy as pie. You can now see the `diff` file that was created for the interface model. The diffs are similar to a typical git diff:

* The `-` refers to what was removed.
* The `+` refers to what was added.

If you open the interface diff file `/home/developer/src/diff_snapshot/diff_interface_nxos_nx-osv-1_ops.txt` you can see that interface Ethernet2/1 was shutdown. 

If you open the ospf diff file `/home/developer/src/diff_snapshot/diff_ospf_nxos_nx-osv-1_ops.txt` you can also see that when we lost the Ethernet2/1 interface we lost an ospf neighbor.

Now you know exactly what needs to be done to repair the network.

Let's take a moment to reflect on what you have learned so far:

* Does this mean I can see over time how the network operation changes **and** exactly what has changed?: **YES**
* Can I use this when pushing new configuration to make sure the changes are as expected?: **YES**
* What about before and after migration; for example, to verify that no Bgp route has been lost?: **YES**
* Even when changing a linecard and making sure all my interfaces and operation is back as expected?: **YES**
* What about ... **YES**. Well, most likely yes!

And finally:

* Can I use the `learn` command on models besides bgp and interface? **YES**: A full list can be found [here](https://pubhub.devnetcloud.com/media/genie-feature-browser/docs/#/models)

You have learned that you can easily take two snapshots of a network and compare them. This important knowledge can be used for many different scenarios. Try to think of some and test it out yourself.

Next, you will see how to use specific `show` commands to learn the network and how to create the testbed file.
