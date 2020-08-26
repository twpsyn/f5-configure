# F5 Configure

This ansible playbook and role are designed to configure the F5s in my lab to a known base state if I foul them up and revert to my fresh build snapshot which basically has them licensed and manageable.

The role (in roles/) is designed to be fairly generic so that I could just lift it for a different deployment. The host and group vars fully define how the F5s will be configured.