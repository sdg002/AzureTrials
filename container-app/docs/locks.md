[[_TOC_]]
# Part 1

```
Code: ScopeLocked
Message: The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com'. Please remove the lock and try again.
ERROR: Some resources failed to be deleted (run with `--verbose` for more information):
/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com
INFO: Command ran in 2.262 seconds (init: 0.487, invoke: 1.775)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: (ScopeLocked) The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com'. Please remove the lock and try again.
Code: ScopeLocked
Message: The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com'. Please remove the lock and try again.
ERROR: Some resources failed to be deleted (run with `--verbose` for more information):
/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: Command ran in 2.037 seconds (init: 0.518, invoke: 1.519)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/saudevuksouth.com
INFO: Command ran in 2.210 seconds (init: 0.474, invoke: 1.736)
No of resources deleted=7 Going to try again
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.App/managedEnvironments/caedemosauuksouth001
INFO: Command ran in 1.924 seconds (init: 0.471, invoke: 1.452)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.OperationalInsights/workspaces/democontainerapplogworkspacedev
INFO: Command ran in 2.012 seconds (init: 0.479, invoke: 1.534)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.ContainerRegistry/registries/saupycontainerregistry001dev
INFO: Command ran in 1.996 seconds (init: 0.489, invoke: 1.507)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.App/containerApps/casaudevuksouth
INFO: Command ran in 1.924 seconds (init: 0.480, invoke: 1.444)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com
INFO: (ScopeLocked) The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com'. Please remove the lock and try again.
Code: ScopeLocked
Message: The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com'. Please remove the lock and try again.
ERROR: Some resources failed to be deleted (run with `--verbose` for more information):
/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com
INFO: Command ran in 2.244 seconds (init: 0.488, invoke: 1.756)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: (ScopeLocked) The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com'. Please remove the lock and try again.
Code: ScopeLocked
Message: The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com'. Please remove the lock and try again.
ERROR: Some resources failed to be deleted (run with `--verbose` for more information):
/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: Command ran in 1.920 seconds (init: 0.488, invoke: 1.431)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/saudevuksouth.com
INFO: Command ran in 2.178 seconds (init: 0.501, invoke: 1.678)
No of resources deleted=7 Going to try again
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.App/managedEnvironments/caedemosauuksouth001
INFO: Command ran in 1.897 seconds (init: 0.486, invoke: 1.411)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.OperationalInsights/workspaces/democontainerapplogworkspacedev
INFO: Command ran in 1.930 seconds (init: 0.484, invoke: 1.446)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.ContainerRegistry/registries/saupycontainerregistry001dev
INFO: Command ran in 1.939 seconds (init: 0.470, invoke: 1.469)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.App/containerApps/casaudevuksouth
INFO: Command ran in 1.917 seconds (init: 0.478, invoke: 1.439)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com
INFO: (ScopeLocked) The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com'. Please remove the lock and try again.
Code: ScopeLocked
Message: The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com'. Please remove the lock and try again.
ERROR: Some resources failed to be deleted (run with `--verbose` for more information):
/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com
INFO: Command ran in 2.354 seconds (init: 0.459, invoke: 1.895)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: (ScopeLocked) The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com'. Please remove the lock and try again.
Code: ScopeLocked
Message: The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com'. Please remove the lock and try again.
ERROR: Some resources failed to be deleted (run with `--verbose` for more information):
/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: Command ran in 1.939 seconds (init: 0.475, invoke: 1.464)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/saudevuksouth.com
INFO: Command ran in 0.832 seconds (init: 0.472, invoke: 0.360)
```


# Part 2
```
/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: Command ran in 2.012 seconds (init: 0.501, invoke: 1.511)
No of resources deleted=2 Going to try again
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com
INFO: Command ran in 2.241 seconds (init: 0.495, invoke: 1.746)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: (ScopeLocked) The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com'. Please remove the lock and try again.
Code: ScopeLocked
Message: The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com'. Please remove the lock and try again.
ERROR: Some resources failed to be deleted (run with `--verbose` for more information):
/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: Command ran in 1.903 seconds (init: 0.475, invoke: 1.428)
No of resources deleted=2 Going to try again
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com
INFO: Command ran in 2.144 seconds (init: 0.474, invoke: 1.671)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: (ScopeLocked) The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com'. Please remove the lock and try again.
Code: ScopeLocked
Message: The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com'. Please remove the lock and try again.
ERROR: Some resources failed to be deleted (run with `--verbose` for more information):
/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: Command ran in 2.086 seconds (init: 0.497, invoke: 1.588)
No of resources deleted=2 Going to try again
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com
INFO: Command ran in 2.147 seconds (init: 0.482, invoke: 1.664)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: (ScopeLocked) The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com'. Please remove the lock and try again.
Code: ScopeLocked
Message: The scope '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com' cannot perform delete operation because following scope(s) are locked: '/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourcegroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com'. Please remove the lock and try again.
ERROR: Some resources failed to be deleted (run with `--verbose` for more information):
/subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: Command ran in 2.009 seconds (init: 0.491, invoke: 1.519)
No of resources deleted=2 Going to try again
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.Network/dnszones/sau001.com
INFO: Command ran in 2.371 seconds (init: 0.487, invoke: 1.884)
Going to delete resource with id: /subscriptions/635a2074-cc31-43ac-bebe-2bcd67e1abfe/resourceGroups/rg-demo-container-apps-dev-uks/providers/Microsoft.DomainRegistration/domains/sau001.com
INFO: Command ran in 1.657 seconds (init: 0.513, invoke: 1.145)
```