# Network snapshot

To take the snapshot of your network you will use the `learn` command from the pyATS Command Line Interface. This command will perform the following tasks:

* Connect to all the devices provided in the testbed file.
* Use the [pyATS Models](https://pubhub.devnetcloud.com/media/genie-feature-browser/docs/#/models) to capture the state of each model you want to capture.
* Write the raw output and parsed output to files.

For more information on the `learn` command, refer to the [documentation](https://pubhub.devnetcloud.com/media/genie-docs/docs/cli/genie_learn.html).

## Initial snapshot

Take an initial snapshot of the `interface`, `ospf`, and `platform` models from your working network.

```bash
cd /home/developer/src

pyats learn interface ospf platform \
            --testbed-file working-tb.yaml \
            --output working_snapshot
```

That's it! You have taken a snapshot of your network for the specified models. The generated files are located in `/home/developer/src/working_snapshot` directory. Here's an overview of what files you can find:

* Connection logs - `connection_<device>.txt`
* Raw command output - `<model>_<os>_<device>_console.txt`
* Parsed output - `<model>_<os>_<device>_ops.txt`

> *Note:*  If you do not see these files or directories, hover over the developer directory and click on the refresh button.
>
>![refresh](images/refresh.png)

The files that contain parsed output are "gold". They enable us to compare the network state. As discussed earlier, comparing plaintext is very difficult. It gives a lot of false positives on information you do not care about.

Next, let's see how to use this snapshot.
