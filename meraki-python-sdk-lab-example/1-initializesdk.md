# Using the SDK to retrieve data from Meraki API

To start using the SDK, navigate to the `meraki-python-sdk` folder.

```bash
cd ~/src/meraki-code/meraki-python-sdk
```

## Understanding the code

Open `meraki_python_sdk_lab.py` in the in-browser text editor and examine the code. 

The line `import meraki` imports the the `meraki` class that holds methods and attributes that allow you to make API calls without having to set up a full request in code. 

We *instantiate* the `meraki` class and save it to the variable `client` with the line `client = meraki.DashboardAPI(api_key=API_KEY)`. 

The line `orgs = client.organizations.getOrganizations()` retrieves the list of **Organizations** that you can access (based on the **API-Key**). Notice this is one line of code, rather than the 4 or 5 that could be used to create the **HTTPS** REST request and call the URL directly.

Note the inclusion of the [`pprint` library](https://docs.python.org/3/library/pprint.html). This library formats the JSON that the API call retrieves into a human-readable format.

The code on line #23 looks specifically for the organization marked **DevNet Sandbox**. Once found, it saves the `organization_id` and uses that to make the next call to get the networks with `client.organizations.getOrganizationNetworks(params["organization_id"])`.

Once the list of networks is received, the code looks for a network named "DevNet Sandbox ALWAYS ON". When that network is identified, its `network_id` is saved and used to retrieve the list of devices with the line `devices = client.networks.getNetworkDevices(network_id)`. 

Run `meraki_python_sdk_lab.py` in the terminal:

```bash
python3.9 meraki_python_sdk_lab.py
```

## Observe the results

You should see a printout of the list of organizations that this user can access.

Now that you have a list of devices, you can monitor status, update configurations, or even remove devices from the network if you have access.

This is one example of how the Meraki SDK enables you to interact with Meraki. To learn more, explore the [Meraki SDK documentation](https://developer.cisco.com/meraki/api-v1/#!sdks-overview).