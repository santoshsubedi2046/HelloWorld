
To revert the changes made by the script and enable Jenkins CLI access over HTTP again, you can follow these steps:

Log in to your Jenkins instance.
Navigate to "Manage Jenkins" from the dashboard.
Choose "Script Console" from the options.
In the script console, you need to run the script to revert the changes made by the previous script. Here's the modified script to revert the changes:
groovy
Copy code
// Re-enable CLI access over HTTP
def j = jenkins.model.Jenkins.get();
j.getExtensionList(hudson.cli.CLIAction.class).addAll(j.getExtensionList(hudson.cli.CLIAction.class))
j.getExtensionList(hudson.ExtensionPoint.class).addAll(j.getExtensionList(hudson.ExtensionPoint.class))
j.getExtensionList(hudson.model.Action.class).addAll(j.getExtensionList(hudson.model.Action.class))
j.getExtensionList(hudson.model.ModelObject.class).addAll(j.getExtensionList(hudson.model.ModelObject.class))
j.getExtensionList(hudson.model.RootAction.class).addAll(j.getExtensionList(hudson.model.RootAction.class))
j.getExtensionList(hudson.model.UnprotectedRootAction.class).addAll(j.getExtensionList(hudson.model.UnprotectedRootAction.class))
j.getExtensionList(java.lang.Object.class).addAll(j.getExtensionList(java.lang.Object.class))
j.getExtensionList(org.kohsuke.stapler.StaplerProxy.class).addAll(j.getExtensionList(org.kohsuke.stapler.StaplerProxy.class))
j.actions.addAll(j.actions)

println "Jenkins CLI access over HTTP re-enabled successfully!"
