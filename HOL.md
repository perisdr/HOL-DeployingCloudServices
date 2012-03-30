<a name="HOLTop" />
# Deploying Applications in Windows Azure #

---
<a name="Overview" />
## Overview ##

In this hands-on lab, you will learn how to deploy your first application in Windows Azure. The lab walks through the process using myTODO, a simple list creation and management application built using ASP.NET MVC. The lab shows the steps required for provisioning the required components in the Windows Azure Management Portal, uploading the service package, and configuring the service. You will see how you can test your application in a staging environment and then promote it to production once you are satisfied that it is operating according to your expectations.
 
![The myTODO application running in Windows Azur](images/mytodo.png?raw=true "The myTODO application running in Windows Azure")

_The myTODO application running in Windows Azure_


In the course of the lab, you will also examine how to deploy, upgrade, and configure Windows Azure applications programmatically using the Service Management API. You will use the Windows Azure Service Management Tools, which wraps the management API, to execute Windows PowerShell scripts that perform these operations. To complete the examination of deployment choices, you will use the Windows Azure Tools to deploy the application directly from Visual Studio.

During the lab, you will also learn how to provide an SSL connection to your Windows Azure service.

<a name="Objectives" />
### Objectives ###

In this hands-on lab, you will learn how to:

- Use the Windows Azure Management Portal to create storage accounts and hosted service components
- Deploy service component packages using the Windows Azure Management Portal user interface
- Change configuration settings for a deployed application
- Test deployments in a separate staging environment before deployment to final production
- Use Windows PowerShell to deploy, upgrade, and configure Windows Azure services programmatically
- Use the Windows Azure Tools for service deployment from Visual Studio
- Secure your Windows Azure application with SSL

<a name="Prerequisites" />
### Prerequisites ###

The following is required to complete this hands-on lab:

- [Microsoft .NET Framework 4.0][1]
- [Microsoft Visual Studio 2010][2]
- [ASP.NET MVC 2][3]
- [Windows Azure Tools for Microsoft Visual Studio 1.6][4]
- IIS 7 (with ASP.NET, WCF HTTP Activation, Tracing)
- [Windows Azure Service Management CmdLets 1.0][5]

[1]: http://go.microsoft.com/fwlink/?linkid=186916
[2]: http://msdn.microsoft.com/vstudio/products/
[3]: http://www.microsoft.com/downloads/details.aspx?FamilyID=c9ba1fe1-3ba8-439a-9e21-def90a8615a9&displaylang=en
[4]: http://www.microsoft.com/windowsazure/sdk/
[5]: http://wappowershell.codeplex.com/


>**Note:** The source code for the Windows Azure Service Management CmdLets is included in the Assets folder and built during setup.

<a name="Setup" />
### Setup ###

In order to execute the exercises in this hands-on lab you need to set up your environment.

1. Open a Windows Explorer window and browse to the lab’s **Source** folder.
2. Double-click the **Setup.cmd** file in this folder to launch the setup process that will configure your environment.
3. If the User Account Control dialog is shown, confirm the action to proceed.

>**Note:**  Make sure you have checked all the dependencies for this lab before running the setup.

---

<a name="Exercises" />
## Exercises ##

This hands-on lab includes the following exercises:

1. [Deploying an Application Using the Windows Azure Management Portal](#Exercise1)

1. [Using PowerShell to Manage Windows Azure Applications](#Exercise2)

1. [Using Visual Studio to Publish Applications](#Exercise3)

1. [Securing Windows Azure with SSL](#Exercise4)

Estimated time to complete this lab: **90 minutes**.

> Note: When you first start Visual Studio, you must select one of the predefined settings collections. Every predefined collection is designed to match a particular development style and determines window layouts, editor behavior, IntelliSense code snippets, and dialog box options. The procedures in this lab describe the actions necessary to accomplish a given task in Visual Studio when using the **General Development Settings collection**. If you choose a different settings collection for your development environment, there may be differences in these procedures that you need to take into account.


<a name="Exercise1" />
### Exercise 1: Deploying an application using the Windows Azure Management Portal ###

In this exercise, you deploy the myTODO application to Windows Azure using the Windows Azure Management Portal. To do this, you provision the required service components at the management portal, upload the application package to the staging environment and configure it. You then execute the application in this test environment to verify its operation. Once you are satisfied that it operates according to your expectations, you promote the application to production.

>**Note:** In order to complete this exercise, you need to sign up for a Windows Azure account and purchase a subscription. 

>For a description of the provisioning process, see [Provisioning Windows Azure](http://blogs.msdn.com/david_sayed/archive/2010/01/07/provisioning-windows-azure.aspx).


<a name="Ex1Task1" />
#### Task 1 – Creating a Storage Account and a Hosted Service Component ####

The application you deploy in this exercise requires both compute and storage services. In this task, you create a new Windows Azure storage account to allow the application to persist its data. In addition, you define a hosted service component to execute application code.

1. Navigate to [http://windows.azure.com](http://windows.azure.com) using a Web browser and sign in using the Windows Live ID associated with your Windows Azure account.


	![Signing in to the Windows Azure Management Portal](images/signing-in-to-the-management-portal.png?raw=true "Signing in to the Windows Azure Management Portal")

	_Signing in to the Windows Azure Management Portal_

1. First, you create the storage account that the application will use to store its data. In the Windows Azure ribbon, click **New Storage Account**.
	
	![Creating a new storage account](images/new-storage-account.png?raw=true "Creating a new storage account")

	_Creating a new storage account_

1. In the **Create a New Storage Account** dialog, pick your subscription in the drop down list labeled **Choose a subscription**. 

	![Choosing a subscription to host the storage account](images/choose-subscription-account.png?raw=true "Choosing a subscription to host the storage account")

	_Choosing a subscription to host the storage account_

1. In the textbox labeled **Enter a URL**, enter the name for your storage account, for example, **\<yourname\>mytodo**, where \<_yourname_\> is a unique name. Windows Azure uses this value to generate the endpoint URLs for the storage account services.

	![Choosing the URL of the new storage account](images/choosing-storage-account-url.png?raw=true "Choosing the URL of the new storage account")

	_Choosing the URL of the new storage account_

	> **Note:**  The name used for the storage account corresponds to a DNS name and is subject to standard DNS naming rules. Moreover, the name is publicly visible and must therefore be unique. The portal ensures that the name is valid by verifying that the name complies with the naming rules and is currently available. A validation error will be shown if you enter a name that does not satisfy the rules.
	
	> ![Occupied DNS](images/occupied-dns.png?raw=true "Occupied DNS")

1. Select the option labeled **Create or choose an affinity group** and then pick **Create a new affinity group** from the drop down list.

	![Creating a new affinity group](images/new-affinity-group.png?raw=true "Creating a new affinity group")
	
	_Creating a new affinity group_

	>**Note:** The reason that you are creating a new affinity group is to deploy both the hosted service and storage account to the same location, thus ensuring high bandwidth and low latency between the application and the data it depends on.

1. In the **Create a New Affinity Group** dialog, enter an **Affinity Group Name**, select its Location in the drop down list, and then click **OK**.

	![Creating a new affinity group](images/new-affinity-group-2.png?raw=true "Creating a new affinity group")
	
	_Creating a new affinity group_

1. Back in the **Create a New Storage Account** dialog, click **Create** to register your new storage account. Wait until the account provisioning process completes and updates the **Storage Accounts** tree view. Notice that the **Properties** pane shows the **URL** assigned to each service in the storage account. Record the public storage account name—this is the first segment of the URL assigned to your endpoints.

	![Storage account successfully created](images/storage-account-created.png?raw=true "Storage account successfully created")
	
	_Storage account successfully created_

1. Now, click the **View** button next to **Primary access key** in the **Properties** pane. In the **View Storage Access Keys** dialog, click **Copy to Clipboard** next to the **Primary Access Key**. You will use this value later on to configure the application.
 
	![Retrieving the storage access keys](images/retrieving-access-keys.png?raw=true "Retrieving the storage access keys")

	_Retrieving the storage access keys_
	
	>**Note:**  The **Primary Access Key** and **Secondary Access Key** both provide a shared secret that you can use to access storage. The secondary key gives the same access as the primary key and is used for backup purposes. You can regenerate each key independently in case either one is compromised.

1. Next, create the compute component that executes the application code. Click **Hosted Services** on the left pane. Click on **New Hosted Service** button on the ribbon.

	![Creating a new hosted service](images/new-hosted-service.png?raw=true "Creating a new hosted service")
	
	_Creating a new hosted service_

1. In the **Create a new Hosted Service** dialog, select the subscription where you wish to create the service from the drop down list labeled **Choose a subscription**.

	![Choosing your subscription](images/choosing-your-subscription.png?raw=true "Choosing your subscription")

	_Choosing your subscription_

1. Enter a service name in the textbox labeled **Enter a name for your service** and choose its URL  by entering a prefix in the textbox labeled **Enter a URL prefix for your service**, for example, **\<_yourname_\>mytodo**, where \<_yourname_\> is a unique name. Windows Azure uses this value to generate the endpoint URLs for the hosted service.

	![Configuring the hosted service URL and affinity group](images/configuring-hosted-service-url.png?raw=true "Configuring the hosted service URL and affinity group")
	
	_Configuring the hosted service URL and affinity group_

	>**Note:** If possible, choose the same name for both the storage account and hosted service. However, you may need to choose a different name if the one you select is unavailable.

	>The portal ensures that the name is valid by verifying that the name complies with the naming rules and is currently available. A validation error will be shown if you enter name that does not satisfy the rules.
	
	> ![Validation error](images/validation-error.png?raw=true "Validation error")

1. Select the option labeled **Create or choose an affinity group** and then pick the affinity group you defined when you created the storage account from the drop down list.

	![Choosing an affinity group](images/choosing-affinity-group.png?raw=true "Choosing an affinity group")
	
	_Choosing an affinity group_

	>**Note:** By choosing this affinity group, you ensure that the hosted service is deployed to the same data center as the storage account that you provisioned earlier.

1. Select the option labeled **Do not Deploy**.

	>**Note:** While you can create and deploy your service to Windows Azure in a single operation by completing the Deployment Options section, for this hands-on lab, you will defer the deployment step until the next task.

1. Click **OK** to create the hosted service and then wait until the provisioning process completes.

	![Hosted service successfully created](images/hosted-service-created.png?raw=true "Hosted service successfully created")
	
	_Hosted service successfully created_

1.	Do not close the browser window. You will use the portal for the next task.

<a name="Ex1Task2" />
#### Task 2 – Deploying the Application to the Windows Azure Management Portal ####

A hosted service is a service that runs your code in the Windows Azure environment. It has two separate deployment slots: staging and production. The staging deployment slot allows you to test your service in the Windows Azure environment before you deploy it to production. 

In this task, you create a service package for the myTODO application and then deploy it to the staging environment using the Windows Azure Management Portal.

1. Open Microsoft Visual Studio 2010 in elevated administrator mode. To do this, in **Start | All Programs | Microsoft Visual Studio 2010**, right-click the **Microsoft Visual Studio 2010** shortcut and choose **Run as Administrator**. 

1. In the **File** menu, choose **Open** and then **Project/Solution**. In the **Open Project** dialog, browse to **Ex1-DeployingWithWAZPortal\Begin** in the **Source** folder of the lab, select **MyTodo.sln** and click Open.

	The solution contains the following projects:

	|        |        |
	|------------------|----------------|
	| MyTodo                   | A standard cloud service project configured to support a single web role named **MyTodo.WebUx**                         |
	| MyTodo.Data.WindowsAzure | A class library project that contains data contracts for the **MyTodo.WebUx** application for table storage |
	| AspProviders             | An implementation of ASP.NET Membership, Role, and SessionState providers for Azure Storage                             |
	| MyTodo.WebUx             | A web role that hosts the MyTODO ASP.NET MVC application in Windows Azure                                               |
	

1. Ensure that the **System.Web.Mvc** assembly is included in the service package that you deploy to Windows Azure.  To do this, expand the **References** node in **Solution Explorer** for the **MyTodo.WebUx** project, right-click the **System.Web.Mvc** assembly and select **Properties**. In the **Project Properties** window, switch to the **References** tab, select the **System.Web.Mvc** assembly, and press **F4**. 

	To add the assembly to the service package, in the **Properties** window for the **System.Web.Mvc** assembly, if **Copy Local** setting is set to _False_ then change it to _True_.

	![Including assemblies in the service package deployed to Windows Azure](images/mvc2-including-assemblies.png?raw=true "Including assemblies in the service package deployed to Windows Azure")

	_Including assemblies in the service package deployed to Windows Azure_

	>**Note:** In general, you need to set **Copy Local = True** for any assembly that is not installed by default in the Windows Azure VMs to ensure that it is deployed with your application. 

1. Next, change the size of the virtual machine that will host the application. To do this, in **Solution Explorer**, expand the **Roles** node of the **MyTodo** project and then double-click the **MyTodo.WebUX** role to open its properties window. In the **Configuration** page, locate the **VM** Size setting under the **Instances** category and choose the **Extra small** size from the drop down list.
 	
	![Configuring the size of the virtual machine for the deployment](images/configuring-vm-depl-size.png?raw=true "Configuring the size of the virtual machine for the deployment")

	_Configuring the size of the virtual machine (VM) for the deployment_

	>**Note:** When you create your service model, you can specify the size of the virtual machine (VM) to which to deploy instances of your role, depending on its resource requirements. The size of the VM determines the number of CPU cores, the memory capacity, the local file system size allocated to a running instance, and the network throughput.

1. To configure the storage before deploying the service, open **ServiceConfiguration.cscfg** file located in **MyTodo** service. Replace the placeholder labeled \[YOUR\_ACCOUNT\_NAME\] with the **Storage Account Name** that you chose when you configured the storage account in Task 1. If you followed the recommendation, the name should follow the pattern **\<yourname\>mytodo**, where  \< _yourname_\>  is a unique name. Make sure to replace both instances of the placeholder, one for the _DataConnectionString_ and the second one for the _Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString_.

1. Next, replace the placeholder labeled \[YOUR\_ACCOUNT\_KEY\] with the **Primary Access Key** value that you recorded earlier, when you created the storage account in Task 1. Again, replace both instances of the placeholder, one for each connection string.

	![Configuring the storage account connection strings](images/configuring-storage-account-connection.png?raw=true "Configuring the storage account connection strings")

	_Configuring the storage account connection strings_

1. Now, define the version of the Windows Azure Guest Operating System that should run your service on the virtual machine. To do this, double-click the **ServiceConfiguration.cscfg** file in the **MyTodo** project to open this file in the XML editor. Now, add an **osVersion** attribute to the **ServiceConfiguration** root element and set its value to _WA-GUEST-OS-1.8\_201010\-01_, as shown in the figure below.

	>**Note:** The value used for **osVersion** here is to illustrate that you can select which release of the guest OS runs your application. You may use a higher version. 

	![Configuring which version of the guest operating system runs the application in the VM](images/configuring-guestOS.png?raw=true "Configuring which version of the guest operating system runs the application in the VM")

	_Configuring which version of the guest operating system runs the application in the VM_

	>**Note:** The Windows Azure Fabric runs a guest operating system into which your service application will be deployed. This guest operating system is regularly updated. While rare, there is some chance that updated guest operating system versions may introduce breaking changes in your application. By setting the **osVersion** attribute, you ensure that your application runs in a version of the Windows Azure guest operating system that is compatible with the version of the Windows Azure SDK with which you developed it. You may then take the time to test each new **osVersion** prior to running it in your production deployment.
	
	>To configure the operating system version, you need to edit the service definition file directly because the current release of the Windows Azure Tools for Microsoft Visual Studio does not support setting this attribute through its user interface. 
	
	>Windows Azure offers an auto-upgrade feature, that automatically upgrades your service to use the latest OS version whenever it becomes available, thus ensuring that your service runs in an environment with the latest security fixes. This is the default mode if you omit an **osVersion** when you deploy your service. To change an existing service to auto-upgrade mode, set the **osVersion** attribute to the value "*".
	
	>For information on available versions of the Windows Azure guest operating system, see [Windows Azure Guest OS Versions and SDK Compatibility Matrix](http://msdn.microsoft.com/en-us/library/ee924680\(v=MSDN.10\).aspx).

1. Press **CTRL + S** to save the changes to the service model.

1. To create a service package, right-click the cloud service project and select **Package**. 

1. In the **Package Windows Azure Application** dialog, click **Package** and then wait until Visual Studio creates it. Once the package is ready, Visual Studio opens a window showing the folder that contains the generated files. Close the window after you see the package.

	![Creating a service package in Visual Studio](images/creating-a-service-package.png?raw=true "Creating a service package in Visual Studio")
	
	_Creating a service package in Visual Studio_

1. Go to the web browser and open the **Summary** page for the project that you created in the previous task.

1. At the portal, select the hosted service that you created in the previous step and then click **New Staging Deployment** on the ribbon. 

	>**Note:** A hosted service is a service that runs your code in the Windows Azure environment. It has two separate deployment slots: staging and production. The staging deployment slot allows you to test your service in the Windows Azure environment before you deploy it to production.
 
	![Hosted service summary page](images/hosted-service-summary-page.png?raw=true "Hosted service summary page")
	
	_Hosted service summary page_

1. In the **Create a new Deployment** dialog, to select a **Package location**, click **Browse Locally**, navigate to the folder where Visual Studio generated the package in Step 10 and then select **MyTodo.cspkg**.  

	>**Note:** The .cspkg file is an archive file that contains the binaries and files required to run a service, in this case, the myTODO ASP.NET MVC application. Visual Studio creates the service package for you when you select **Package** for your Windows Azure project.

1. Now, to choose the **Configuration File**, click **Browse Locally** and select **ServiceConfiguration.cscfg** in the same folder that you used in the previous step.

	>**Note:** The _.cscfg_ file contains configuration settings for the application, including the instance count that you will update later in the exercise.

1. Finally, for the **Deployment name**, enter a label to identify the deployment; for example, use **v1.0**.

	>**Note:** The management portal displays the label in its user interface for staging and production, which allows you to identify the version currently deployed in each environment.
	
	![Configuring service package deployment](images/configuring-service-package-deployment.png?raw=true "Configuring service package deployment")

	_Configuring service package deployment_

1. Click **OK** to start the deployment. Notice that the portal displays a warning message when you do this. Click **See more details** to review and understand the message.
 
	![Reviewing the warnings](images/warnings-rev.png?raw=true "Reviewing the warnings")

	_Reviewing the warnings_
	
	>**Note:** In this particular case, the warning indicates that only a single instance is being deployed for at least one of the roles. This is not recommended because it does not guarantee the service’s availability. In the next task, you will increase the number of instances to overcome this issue.
	
	
	>![Deployment warning] (images/deployment-warning.png?raw=true "Deployment warning")

1. Click **Yes** to override and submit the deployment request. Notice that the package begins to upload and that the portal shows the status of the deployment to indicate its progress.

	![Uploading a service package to the Windows Azure Management Portal](images/uploading-service-package-waz.png?raw=true "Uploading a service package to the Windows Azure Management Portal")

	_Uploading a service package to the Windows Azure Management Portal_

1. Wait until the deployment process finishes, which may take several minutes. At this point, you have already uploaded the package and it is in a **Ready** state. Notice that the portal assigned a **DNS name** to the deployment that includes a unique identifier. Shortly, you will access this URL to test the application and determine whether it operates correctly in the Windows Azure environment, but first you need to configure it.

	>**Note:** During deployment, Windows Azure analyzes the configuration file and copies the service to the correct number of machines, and starts all the instances. Load balancers, network devices and monitoring are also configured during this time.
 	
	![Package successfully deployed](images/package-deployed.png?raw=true "Package successfully deployed")

	_Package successfully deployed_

<a name="Ex1Task3" />
#### Task 3 – Configuring the Application to Increase Number of Instances ####

Before you can test the deployed application, you need to configure it. In this task, you change the service configuration already deployed to increase the number of instances.

1. In **Hosted Services**, select your MyTodo service and click **Configure** on the ribbon.
 
	![Configuring application settings] (images/configuring-app-settings.png?raw=true "Configuring application settings")

	_Configuring application settings_

1. In the **Configure Deployment** dialog, select the option labeled **Edit current configuration**, locate the **Instances** element inside the **MyTodo.WebUX** configuration and change its count attribute to _2_. 
 
	>**Note:** The configuration is simply an XML document that contains the value of the settings declared in the service definition file. Its initial content is determined by the **ServiceConfiguration.cscfg** file that you uploaded earlier, when you deployed the package in Task 2.

	![Configuring the Instances count] (images/configuring-instances-count.png?raw=true "Configuring the Instances count")
	
	_Configuring the Instances count_

	>**Note:** The **Instances** setting controls the number of roles that Windows Azure starts and is used to scale the service. For a token-based subscription—currently only available in countries that are not provisioned for billing—this number is limited to a maximum of two instances. However, in the commercial offering, you can change it to any number that you are willing to pay for.

1. Click **OK** to update the configuration and wait for the hosted service to apply the new settings.
 	
	![Updating the number of role instances](images/updating-number-role-instances.png?raw=true "Updating the number of role instances")
	
	_Updating the number of role instances_

	>**Note:** The portal displays a legend "Updating deployment..." while the settings are applied.


<a name="Ex1Task4" />
#### Task 4 – Testing the Application in the Staging Environment ####

In this task, you run the application in the staging environment and access its Web Site URL to test that it operates correctly.

1. In **Hosted Services**, select your MyTodo service and then click the link located in the right pane under **DNS name**.

	![Running the application in the staging environment](images/running-app-staging.png?raw=true "Running the application in the staging environment")

	_Running the application in the staging environment_

	>**Note:** The address URL is shown as _\<guid\>.cloudapp.net_, where \<_guid_\> is some random identifier. This is different from the address where the application will run once it is in production. Although the application executes in a staging area that is separate from the production environment, there is no actual physical difference between staging and production – it is simply a matter of where the load balancer is connected.
	
	>**Note:** In the future, you will be able to have multiple “virtual” areas, for test, QA, pre-production, etc... 

1. Click **Start** to prepare the application for first time use, which requires you to create a new account. To do this, navigate to register menu.
 	
	![Application running in the staging environment](images/application-running-staging.png?raw=true "Application running in the staging environment")

	_Application running in the staging environment_

1. Complete the account details by entering a user name, email address, and password and then click **Register**. 

	>**Note:**  Account information is stored in the storage account created earlier. Data is not shared between to do lists.

	![Application ready to be used](images/application-new-account.png?raw=true "Application ready to be used")
 
	_Creating a new account_

1. Next, the application enumerates the lists that you have currently defined. Since this is your first use, no lists should appear.

	![Application ready to be used](images/application-ready.png?raw=true "Application ready to be used")

	_Application ready to be used_

1. If you wish to explore the application, create a new TODO list and enter some items. 


<a name="Ex1Task5" />
#### Task 5 – Promoting the Application to Production ####

Now that you have verified that the service is working correctly in the staging environment, you are ready to promote it to final production.  When you deploy the application to production, Windows Azure reconfigures its load balancers so that the application is available at its production URL.

1. In **Hosted Services**, select your MyTodo service and then click **Swap VIP** on the ribbon.
 
	![Promoting the application to the production slot](images/promoting-app-prod.png?raw=true "Promoting the application to the production slot")

	_Promoting the application to the production slot_

1. On the **Swap VIPs** dialog, click **OK** to swap the deployments between staging and production.
 
	![Promoting the application to the production deployment](images/promoting-app-deploy.png?raw=true "Promoting the application to the production deployment")
	
	_Promoting the application to the production deployment_

1. Click the **DNS name** link to open the production site in a browser window and notice the URL in the address bar.
 
	![Application running in the production environment](images/application-running-production.png?raw=true "Application running in the production environment")

	_Application running in the production environment_


	>**Note:** If you visit the production site shortly after its promotion, the DNS name might not be ready. If you encounter a DNS error (404), wait a few minutes and try again. Keep in mind that Windows Azure creates DNS name entries dynamically and that the changes might take few minutes to propagate.

	>**Note:** Even when a deployment is in a suspended state, Windows Azure still needs to allocate a virtual machine (VM) for each instance and charge you for it. Once you have completed testing the application, you need to remove the deployment from Windows Azure to avoid an unnecessary expense. To remove a running deployment, go to **Hosted Services**, select the deployment slot where the service is currently hosted, staging or production, and then click **Stop** on the ribbon. Once the service has stopped, click **Delete** on the ribbon to remove it.


<a name="Exercise2" />
### Exercise 2: Using PowerShell to manage Windows Azure Applications ####

Typically, during its lifetime, an application undergoes changes that require it to be re-deployed. In the previous exercise, you saw how to use the Windows Azure Management Portal to deploy applications. As an alternative, the Service Management API provides programmatic access to much of the functionality available through the Management Portal. Using the Service Management API, you can manage your storage accounts and hosted services, your service deployments, and your affinity groups.

The Windows Azure Service Management PowerShell Cmdlets wrap the Windows Azure Service Management API. These cmdlets make it simple to automate the deployment, upgrade, and scaling of your Windows Azure application. By pipelining commands, you compose complex scripts that use the output of one command as the input to another.

In this exercise, you will learn how to deploy and upgrade a Windows Azure application using the Azure Services Management Cmdlets. 


<a name="Ex2Task1" />
#### Task 1 – Generating a Self-Signed Certificate (Optional) ####

To ensure that access to the Service Management API is secure, you must first associate a certificate with your subscription. The management service uses the certificate to authenticate requests. You can use a self-signed certificate or one signed by a certification authority. Any valid X.509 v3 is suitable as long as its key length is at least 2048 bits.

In this task, you generate a certificate that you can upload to the Windows Azure Management Portal. This step is optional if you already have a certificate signed by a certificate authority. 

1. Open a **Visual Studio Command Prompt** as administrator from **Start | All Programs | Microsoft Visual Studio 2010 | Visual Studio Tools | Visual Studio Command Prompt (2010)** by right-clicking the **Visual Studio 2010 Command Prompt** shortcut and choosing **Run as administrator**. 

1. Change the current directory to the location where you wish to store your certificate file.

1. At the prompt, type the following command to generate a local certificate file. 

	<!--mark: 1-->
	```` VisualStudioCommandPrompt
	makecert -r -pe -n "CN=AzureMgmt" -a sha1 -len 2048 -ss My "AzureMgmt.cer"
	````
	
	>**Note:** This command creates a new self-signed certificate with a key length of 2048 bits, writes it to the _"AzureMgmt.cer"_ file in the current directory and saves it to the My certificate store for the current user. 

<a name="Ex2Task2" />
#### Task 2 – Preparing the Windows Azure Account ####

To use the Windows Azure Service Management API, you need to upload the certificate to your Windows Azure account to provide the required authentication. In addition, the management API, and the PowerShell cmdlets that wrap it, require you to provide several pieces of information, including the name of your service, the thumbprint of the certificate, and the subscription ID of your Windows Azure account.

In this task, you upload the certificate to your Windows Azure Account and obtain the required information, including the certificate thumbprint and the subscription ID.  

1. Navigate to [https://windows.azure.com](https://windows.azure.com) using a Web browser and sign in using your Windows Live ID. 

1. Click **Hosted Services, Storage Accounts & CDN**, and then click on **Management Certificates** on the left pane. Click the **Add Certificate** button on the Ribbon.
 

	![Managing API certificates in the Windows Azure Management Portal](images/managing-certificates.png?raw=true "Managing API certificates in the Windows Azure Management Portal")
	
	_Managing API certificates in the Windows Azure Management Portal_

1. Select your subscription and upload the new certificate from your local storage. To do this, select **Browse**, locate the certificate file in your local disk and then click **OK**. 
 
	![Adding a new Management Certificate](images/adding-certificate.png?raw=true "Adding a new Management Certificate")
 
	_Adding a new Management Certificate_

	>**Note:** The Service Management API accepts any valid X.509 v3 certificate for authentication purposes provided its key length is at least 2048 bits. You can use the self-signed certificate you created in the previous task or one signed by a certificate authority. 
	
	>If you submit a self-signed certificate immediately after you generate it, the Windows Azure Management Portal could reject it due to timing differences with your computer if the server’s time is ahead of the **Valid** From date of the certificate. If you receive a **"Certificate is not yet valid"** error when you upload the certificate, you can either wait a few minutes to account for the time skew and re-submit the certificate or use **makecert** to generate a new certificate that specifies a validity period with a start date that is in the past.

1. Make a note of the value shown in the **Thumbprint** for the certificate that you just installed. In addition, make a note of the value shown in **Subscription Id** for the Subscription where you installed the certificate. You can do this by clicking the Subscription root node.
 
	![Certificate Properties](images/certificate-thumbprint.png?raw=true "Certificate Properties")

	_Certificate Properties_

		
	![Subscription Properties](images/subscription-properties.png?raw=true "Subscription Properties")

	_Subscription Properties_
	
1. Select **Hosted Services** on the left pane. Click on the MyTodo service v1.0. You can retrieve the service name from the **DNS name** link shown in **Properties**, which has the format _http://**\<SERVICE_NAME\>**.cloudapp.net_.
 
	![Retrieving the DNS name of the hosted service](images/hosted-services-dns-name.png?raw=true "Retrieving the DNS name of the hosted service")
	
	_Retrieving the DNS name of the hosted service_

	>**Note:** You will use the certificate **Thumbprint**, account **Subscription ID**, and **Service Name** in the next task, when you deploy the service package.
	
	>You may want to copy these values and paste them into Notepad for easy access.

	
<a name="Ex2Task3" />
#### Task 3 – Uploading a Service Package Using Windows PowerShell ####

In the previous exercise, you uploaded the service package for the myTODO application using the Windows Azure Management Portal. In this task, you deploy the package using the Windows Azure Service Management PowerShell cmdlets instead. 

1. If it is not already open, launch Microsoft Visual Studio 2010 as administrator. To do this, in **Start | All Programs | Microsoft Visual Studio 2010**, right-click the **Microsoft Visual Studio 2010** shortcut and choose **Run as administrator**.

1. In the **File** menu, choose **Open** and then **Project/Solution**. In the **Open Project** dialog, browse to **Ex2-DeployingWithPowerShell\Begin** in the **Source** folder of the lab, select **MyTodo.sln** and click Open.

1. Configure the storage account connection strings. To do this, expand the **Roles** node in the **MyTodo** project and double-click the **MyTodo.WebUX** role. In the role properties window, select the **Settings** tab, select the _DataConnectionString_ setting, ensure that the **Type** is set to Connection String, and then click the button labeled with an ellipsis.
 
	![Defining storage account connection settings](images/defining-connection-settings.png?raw=true "Defining storage account connection settings")
	
	_Defining storage account connection settings_

1. In the **Storage Connection String** dialog, choose the **Enter storage credentials** option. Complete your storage **Account Name** and storage **Account Key** and click **OK**.
 
	![Configuring the storage account name and account key](images/defining-connection-settings-2.png?raw=true "Configuring the storage account name and account key")
	
	_Configuring the storage account name and account key_

	>**Note:** This information is available in the **Summary** section of your storage account in the Windows Azure Management Portal. You used the same settings in Exercise 1, when you deployed and configured the application. In that instance, because you were running the application in Windows Azure, you updated the configuration at the Management Portal. 

1. Repeat the previous steps to configure the _Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString_ setting using the same account information.

1. To create a service package, right-click the cloud service project and select **Package**. In the **Package Windows Azure Application** dialog, click **Package** and then wait until Visual Studio creates it. Once the package is ready, Visual Studio opens a window showing the folder that contains the generated files. Close the window after you see the package.

1. Open a Windows PowerShell command prompt. On Windows Vista, Windows Server 2008, and later versions of Windows, in the **Start** menu, open **All Programs | Accessories | Windows PowerShell**, and then select **Windows PowerShell**. On Windows XP and Windows Server 2003, in the **Start** menu, open **Programs | Accessories | Windows PowerShell**, and then select **Windows PowerShell**.

1. At the PowerShell prompt, enter the following command to add support for the Azure Services Management cmdlets to the current session.

	<!--mark: 1-->
	````PowerShell
	Add-PSSnapin AzureManagementToolsSnapIn	
	````

1. Change the current directory to the location where you generated the service package for the myTODO application in Step 6. 

1. Next, enter the command shown below. Use the following command line arguments ensuring that you replace the parameter placeholders with the settings that apply to your service account, which you determined in Task 1 of this exercise.

	<!--mark: 1-->
	````PowerShell
	New-Deployment -serviceName <YOUR_SERVICE_NAME_LOWER_CASE> -subscriptionId <YOUR_SUBSCRIPTION_ID> -certificate (get-item cert:\CurrentUser\MY\<YOUR_CERTIFICATE_THUMBPRINT>) -slot staging –package <PACKAGE_LOCATION> -configuration <CONFIGURATION_LOCATION> -label "v2.0" –storageServiceName <YOUR_STORAGE_SERVICE_NAME_LOWER_CASE>
	````
	|         |               |
	|---------|---------------|
	| \<YOUR_SERVICE_NAME_LOWER_CASE\>         | The service name chosen when configuring the hosted service URL in Exercise 1, not its Service Label |
	| \<YOUR_SUBSCRIPTION_ID\>                 | The subscription ID of the Windows Azure account where the service will be deployed.                 |
	| \<YOUR_CERTIFICATE_THUMBPRINT\>          | The thumbprint value (in upper case) for the certificate uploaded previously.                        |
	| \<PACKAGE_LOCATION\>                     | A path to a local file or the URL of the blob in Azure Storage that contains the service package.    |
	| \<CONFIGURATION_LOCATION\>               | A path to a local file or the public URL of the blob that contains the service configuration file.   |
	| \<YOUR_STORAGE_SERVICE_NAME_LOWER_CASE\> | The storage account name.                                                                            |


	>**Note:** The command shown above uses the **New-Deployment** cmdlet to upload a service package and create a new deployment in the staging environment. It assigns a "v2.0" label to identify this deployment.
	
	>Note that the **certificate** parameter expects a certificate object. In order to retrieve the required certificate, you can use **get-item** and the PowerShell certificate provider to obtain the certificate given its thumbprint value. Be aware that you need to specify the thumbprint in upper case for this method to succeed. 
	
	>**Important:** The **New-Deployment** cmdlet assumes that the compute service and storage service names are the same. If this is not the case, specify an additional parameter -**StorageServicename \<YOUR_SERVICE_NAME_LOWER_CASE\>**, replacing the placeholder with the name of the storage service name.

	For example, to deploy a hosted service named **"yournametodo"**, using an account with a subscription ID of **12abb234-45c9-4b37-8179-e7d88617cb5e**, a certificate thumbprint **6062B026CF12FE6CD1E3A2CE22893E5CD1DA59C7**, for a package named **MyTodo.cspkg** and a configuration file named **ServiceConfiguration.cscfg** stored in the current directory, and to assign this deployment a label **v2.0**, use the following command. 

	![New-Deployment command line](images/command-line-new-deployment.png?raw=true "New-Deployment command line")
	
	_New-Deployment command line_
	
	
1. Press **ENTER** to execute the command. Because **New-Deployment** is an asynchronous operation, the command returns immediately. Meanwhile, the operation continues in the background.
 

	![Deploying a new service package to Windows Azure using PowerShell](images/command-line-deploying-powershell.png?raw=true "Deploying a new service package to Windows Azure using PowerShell")

	_Deploying a new service package to Windows Azure using PowerShell_

1. In the Windows Azure Management Portal, open the **Summary** page and notice how the deployment for the staging environment shows its status with the message "**Updating deployment...**" in the UI. It may take a few seconds for the service status to refresh. Wait for the deployment operation to complete and display the status as **Stopped**.

	>**Note:** Normally, you will not use the management portal to view the status and determine the outcome of your deployment operations. Here, it is shown to highlight the fact that you can use the management API to execute the same operations that are available in the management portal. In the next task, you will see how to use a cmdlet to wait for the operation to complete and retrieve its status.

1. Keep Microsoft Visual Studio and the PowerShell console open. You will need them for the next task.

<a name="Ex2Task4" />
#### Task 4 – Upgrading a Deployment Using Windows PowerShell ####

In this task, you use the Windows Azure Service Management PowerShell cmdlets to upgrade an existing deployment. First, you change the original solution by making minor changes to its source code to produce an updated version of the application. Next, you build the application and create a new service package that contains the updated binaries. Finally, using the management cmdlets, you re-deploy the package to Windows Azure. 

1. Go back to Microsoft Visual Studio. 

1. Open the master page of the application for editing. To do this, in **Solution Explorer**, double-click **Site.Master** in the **Views\Shared** folder of the **MyTodo.WebUx** project. Switch to source mode.

1. Insert a new caption in the footer area of the page. Go to the bottom of the master page and update the copyright notice with the text "(_Deployed with the PowerShell CmdLets_)" as shown below.

	<!--mark: 1-12-->
	````HTML
	...
		</div>
		<div id="footer">
		  <hr />
		  <p class="copyright">
			 &copy; 2009 Microsoft Corporation.  All rights reserved. (Deployed with the PowerShell CmdLets)</p>
		  <p class="powered"><a href="http://www.microsoft.com/azure/windowsazure.mspx"><img src="<%=Url.Content("~/Content/images/powered-by-azure.png")%>" width="188" height="38" alt="Powered by Windows Azure" /><a/></p>
		</div>
		<asp:ContentPlaceHolder ID="ScriptsContent" runat="server" />
	  </div>
	</body>
	</html>
	````
	
1. Generate a new service package. To do this, in **Solution Explorer**, right-click the cloud service project and select **Package**. In the **Package Windows Azure Application** dialog, click **Package** and then wait until Visual Studio creates it. Once the package is ready, Visual Studio opens a window showing the folder that contains the generated files. 

1. Switch to the PowerShell console and enter the command shown below, specifying the settings that apply to your service account where indicated by the placeholder parameters. Do **not** execute the command yet.

	<!--mark: 1-3-->
	````PowerShell
	Get-HostedService -serviceName <YOUR_SERVICE_NAME> -subscriptionId <YOUR_SUBSCRIPTION_ID> -certificate (get-item cert:\CurrentUser\MY\<YOUR_CERTIFICATE_THUMBPRINT>) |
	  Get-Deployment staging |
	  Set-Deployment -package <PACKAGE_LOCATION> -configuration <CONFIGURATION_LOCATION> -label "v2.1"
	````
	
	|       |        |
	|-------|--------|
	| \<YOUR_SERVICE_NAME_LOWER_CASE\>         | The service name chosen when configuring the hosted service URL in Exercise 1, not its Service Label |
	| \<YOUR_SUBSCRIPTION_ID\>                 | The subscription ID of the Windows Azure account where the service will be deployed.                 |
	| \<YOUR_CERTIFICATE_THUMBPRINT\>          | The thumbprint value (in upper case) for the certificate uploaded previously.                        |
	| \<PACKAGE_LOCATION\>                     | A path to a local file or the URL of the blob in Azure Storage that contains the service package.    |
	| \<CONFIGURATION_LOCATION\>               | A path to a local file or the public URL of the blob that contains the service configuration file.   |

	>**Note:** The command line shown above concatenates a sequence of cmdlets. First, it obtains a reference to the hosted service using **Get-HostedService**, then it uses **Get-Deployment** to retrieve its _staging_ environment, and finally it uploads the package using **Set-Deployment**. This is done to illustrate how to compose a complex command using the PowerShell pipeline. In fact, in this particular case, you could instead provide all the required information to **Set-Deployment** to achieve the same result. For example:
	
	>Set-Deployment -subscriptionId **\<YOUR_SUBSCRIPTION_ID\>** -certificate **\<YOUR_CERTIFICATE\>** -serviceName **\<YOUR_SERVICE_NAME_LOWER_CASE\>** -slot staging -package **\<PACKAGE_LOCATION\>** -label **\<LABEL\>** 

	
	>**Important:** The **Set-Deployment** cmdlet assumes that the compute service and storage service names are the same. If this is not the case, specify an additional parameter **-StorageServicename \<YOUR_SERVICE_NAME_LOWER_CASE\>**, replacing the placeholder with the name of the storage service name.
	
1. If you were to run the command as described above, the operation runs asynchronously. To show the operation’s progress while the deployment is taking place, you can pipe the output of the command into the **Get-OperationStatus** cmdlet and specify the **WaitToComplete** parameter. Add this cmdlet to the end of the command line entered previously making sure that you include the pipeline character '|', as shown below. 
	
	<!--mark: 1-4-->
	````PowerShell
	Get-HostedService <YOUR_SERVICE_NAME_LOWER_CASE> -subscriptionId <YOUR_SUBSCRIPTION_ID> -certificate (get-item cert:\CurrentUser\MY\<YOUR_CERTIFICATE_THUMBPRINT>) |
	  Get-Deployment staging |
	  Set-Deployment -package <PACKAGE_LOCATION> -configuration <CONFIGURATION_LOCATION> -label "v2.1" |
	  Get-OperationStatus -WaitToComplete
	````

	![Using the PowerShell pipeline to upgrade a deployment](images/command-line-powershell-upgrading-deployment.png?raw=true "Using the PowerShell pipeline to upgrade a deployment")
	
	_Using the PowerShell pipeline to upgrade a deployment_
	
1. Press **ENTER** to execute the command. Wait until the deployment process finishes, which may take several minutes. When the operation ends, it displays a message with the outcome of the operation; if the deployment completed without errors, you will see the message "Succeeded".
  
	![PowerShell console showing the status of the package deployment operation](images/command-line-powershell-status.png?raw=true "PowerShell console showing the status of the package deployment operation")
	
	_PowerShell console showing the status of the package deployment operation_

	>**Note:** Deploying a package using the steps described above does not change its state. If the service is not running prior to deployment, it will remain in that state. To start the service, you need to update its deployment status using the **Set-DeploymentStatus** cmdlet.

1. To change the status of the service to a running state, in the **PowerShell** console, enter the following command.
PowerShell Console

	<!--mark: 1-3-->
	````PowerShell
	Get-Deployment staging -serviceName <YOUR_SERVICE_NAME_LOWER_CASE> -subscriptionId <YOUR_SUBSCRIPTION_ID> -certificate (get-item cert:\CurrentUser\MY\<YOUR_CERTIFICATE_THUMBPRINT>) |
	  Set-DeploymentStatus running |
	  Get-OperationStatus –WaitToComplete
	````
	
1. Finally, swap the deployments in the staging and production environments. To do this, in the **PowerShell** console, use the **Get-Deployment** and **Move-Deployment** cmdlets, as shown below,  ensuring that you replace the placeholder parameters, **\<YOUR_SERVICE_NAME\>**, **\<YOUR_SUBSCRIPTION_ID\>**,  and **\<YOUR_CERTIFICATE_THUMBPRINT\>** with the same values used previously, when you deployed the package.

	<!--mark: 1-5-->
	````PowerShell
	Get-HostedServices -subscriptionId <YOUR_SUBSCRIPTION_ID> -certificate (get-item cert:\CurrentUser\MY\<YOUR_CERTIFICATE_THUMBPRINT>) |
	  where {$_.ServiceName –eq “<YOUR_SERVICE_NAME>”} |
	  Get-Deployment staging |
	  Move-Deployment | 
	  Get-OperationStatus –WaitToComplete
	````

<a name="Ex2Verification" />
#### Verification ####

Now that you have deployed your updated solution to Window Azure, you are now ready to test it. You will launch the application to determine if the deployment succeeded and ensure that the service is working correctly and is available at its production URL. 

1. In the **Summary** page of the management portal, under the **Hosted Service** section, click the **Web Site URL** link to open the production site in a browser window. Notice the footer of the page. It should reflect the updated text that you entered in the last task.

	![New deployment showing the updated footer text](images/new-deployment.png?raw=true "New deployment showing the updated footer text")
	
	_New deployment showing the updated footer text_
	
	>**Note:** If you visit the production site shortly after its promotion, the DNS name might not be ready. If you encounter a DNS error (404), wait a few minutes and try again. Keep in mind that Windows Azure creates DNS name entries dynamically and that the changes might take few minutes to propagate.
	
	
	
<a name="Exercise3" />
### Exercise 3: Using Visual Studio to Publish Applications ####

Previously, you learnt how to deploy applications to Windows Azure using the Management Portal and a set of PowerShell cmdlets. If you are a developer, you may find it more convenient during your development cycle to deploy your applications directly from Visual Studio. 

The first time you publish a service to Windows Azure using Visual Studio, you need to create the necessary credentials to access your account. This involves generating a self-signed certificate that you can upload to the Windows Azure Management Portal. In Exercise 2 of this lab, you followed a similar procedure when you created a certificate using the makecert utility. Visual Studio streamlines this process and allows you to generate the certificate by specifying the necessary information by way of its UI. 

Once you set up your account information in Visual Studio, you can publish your current solution in the background with only a few mouse clicks.

In this exercise, you set up the credentials to authenticate with the Windows Azure Management Service and then publish the MyTodo application from Visual Studio.


<a name="Ex3Task1" />
#### Task 1 – Preparing the Solution for Publish ####

When you publish your service using Visual Studio, the Windows Azure Tools upload the service package and then automatically start it. You will not have a chance to update the configuration settings before the service starts. Therefore, you must configure all the necessary settings before you publish the service.

In this task, you update the storage connection strings to point to your Windows Azure storage account.

1. Open Microsoft Visual Studio 2010 as administrator. To do this, in **Start | All Programs | Microsoft Visual Studio 2010**, right-click the **Microsoft Visual Studio 2010** shortcut and choose **Run as Administrator**. 

1. In the **File** menu, choose **Open** and then **Project/Solution**. In the **Open Project** dialog, browse to **Ex3-DeployingWithVisualStudio\Begin** in the **Source** folder of the lab, select **MyTodo.sln** and click **Open**.

1. In **Solution Explorer**, expand the **Roles** node inside the **MyTodo** cloud project and then double-click the **MyTodo.WebUx** role.

1. In the **MyTodo.WebUx \[Role\]** window, switch to the **Settings** tab and configure the necessary Azure Storage account details replacing [YOUR\_ACCOUNT\_NAME] with the name of your storage account and [YOUR\_ACCOUNT\_KEY] with the shared key. Do this for both _DataConnectionString_ and _Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString_ settings. These are the same values that you used in previous exercises to configure the application.

1. Press **CTRL + S** to save your changes. 

<a name="Ex3Task2" />
#### Task 2 – Generating a Self-Signed Certificate in Visual Studio ####

In this task, you create a second management certificate using Visual Studio—you created the first one earlier using a command line tool—and then upload it to the Windows Azure Management Portal.

1. If it is not already opened, launch **Microsoft Visual Studio 2010** as administrator. To do this, in **Start | All Programs | Microsoft Visual Studio 2010**, right-click the **Microsoft Visual Studio 2010** shortcut and choose **Run as administrator**.

1. In the **File** menu, choose **Open** and then **Project/Solution**. In the **Open Project** dialog, browse to **Ex3-DeployingWithVisualStudio\Begin** in the **Source** folder of the lab, select **MyTodo.sln** and click **Open**.

	>**Note:** This is the same solution deployed earlier except for a legend in its footer area to indicate that it was deployed using **Visual Studio**.

1. In **Solution Explorer**, right-click the **MyTodo** cloud project and select **Publish**.

1. It will prompt the **Publish Windows Azure Application** dialog. To publish an application, you first need to create the necessary credentials to access your Windows Azure account. To add a new set of credentials to your configuration, expand the **Subscription** drop down list and select **Manage**. If you have already added your credentials, chose them and skip this task.
 
	![Adding Subscription's credentials in Visual Studio](images/adding-subscription-credentials.png?raw=true "Adding Subscription's credentials in Visual Studio")
	
	_Adding Subscription's credentials in Visual Studio_

1. It will prompt a dialog to manage your Windows Azure authentication settings. Click **New** to define you authentication settings.
 
	![Adding Authentication Settings](images/adding-auth-settings.png?raw=true "Adding Authentication Settings")
 
	_Adding Authentication Settings_

1. To create the credentials, you require a certificate. If Visual Studio cannot find a suitable certificate in your personal certificate store, it will prompt you to create a new one; otherwise, in the **Windows Azure Project Management Authentication** dialog, expand the drop down list labeled **Create or select an existing certificate for authentication** and then select **Create**.
 
	![Creating a new certificate for authentication](images/creating-certificate.png?raw=true "Creating a new certificate for authentication")

	_Creating a new certificate for authentication_

	>**Note:** The drop down list contains all the certificates that are suitable for authentication with the Azure Management API. This list includes the certificate you created earlier, during the PowerShell deployment exercise. Nevertheless, in this exercise, you create a new certificate to walk through the procedure required to generate certificates in Visual Studio.

1. In the **Create Certificate** dialog, enter a suitable name for the certificate, for example, _AzureMgmtVS_, and then click **OK**.
 
	![Creating a new management certificate](images/creating-certificate-name.png?raw=true "Creating a new management certificate")
	
	_Creating a new management certificate_

1. Back in the **Windows Azure Project Management Authentication** dialog, ensure that the newly created certificate is selected. Notice that the issuer for this certificate is the Windows Azure Tools.
 
	![Selecting a certificate for the credentials](images/selecting-certificate-credentials.png?raw=true "Selecting a certificate for the credentials")
	
	_Selecting a certificate for the credentials_

1. Now, click the link labeled **Copy the full path**. This copies the path of the certificate public key file to the clipboard.

	![Copying the path of the certificate public key file to the clipboard](images/copying-certificates-path.png?raw=true "Copying the path of the certificate public key file to the clipboard")
 
	_Copying the path of the certificate public key file to the clipboard_

	>**Note:** Visual Studio stores the public key file for the certificate it generates in a temporary folder inside your local data directory. 

1. Click **OK** to dismiss the confirmation message box and then save the path in the clipboard to a safe location. You will need this value shortly, when you upload the certificate to the management portal.
 
	![Confirmation that the file path was copied to the clipboard successfully](images/copying-certificates-path-confirmation.png?raw=true "Confirmation that the file path was copied to the clipboard successfully")
	
	_Confirmation that the file path was copied to the clipboard successfully_

1. Next, click the link labeled **Windows Azure Portal** to open a browser window and navigate to the Windows Azure Management Portal.
 
	![Opening the Developer Portal in your browser](images/opening-dev-portal.png?raw=true "Opening the Developer Portal in your browser")
	
	_Opening the Developer Portal in your browser_

1. At the Management Portal, sign in and then upload the certificate that you generated in Visual Studio using the same procedure described in **Task 2** of the previous exercise. Refer to that section of the document for detailed instructions.
If you did not keep a record of the **Subscription ID** of your account, make a note of this value from the **Account** page now. You will require it for the next step.
At the **API Certificates** page, when selecting a certificate file from your local storage, make sure to use the path that you copied earlier from your clipboard to specify the certificate public key file to upload. 

1. To complete the setup of your credentials, switch back to the **Windows Azure Project Management Authentication** dialog, enter your **subscription ID** and a name to identify the credentials and then click **OK**. 
 
	![Completing the credential setup procedure](images/completing-credential-setup.png?raw=true "Completing the credential setup procedure")
	
	_Completing the credential setup procedure_

1. After you confirm the creation of the new credentials, Visual Studio uses them to access the management service to verify that the information that you provided is valid and notifies you if authentication fails. If this occurs, verify the information that you entered and then re-attempt the operation once again.
 
	![Authentication failure while accessing the management service](images/management-service-authentication-failure.png?raw=true "Authentication failure while accessing the management service")
	
	_Authentication failure while accessing the management service_

1. In the **Windows Azure Project Management Settings** dialog, you will see the recently created Authentication setting. Click **Close** to return to the Publish Wizard. You will continue with the publishing process in the next task.
 
	![Managing Authentication settings](images/managing-authentication.png?raw=true "Managing Authentication settings")
	
	_Managing Authentication settings_

	
<a name="Ex3Task3" />
#### Task 3 – Publishing a Service with the Windows Azure Tools ####

In the previous task, you configured a set of credentials that provide access to your Windows Azure account. Visual Studio saves this information and allows you to reuse the credentials whenever you need to publish a service, without requiring you to enter your credentials again. 

In this task, you use these credentials to publish the MyTODO application directly from Visual Studio.

1. In the **Publish Windows Azure Application** dialog, select the credentials that you created in the previous task and click **Next**.
 
	![Signing In](images/waz-sign-in.png?raw=true "Signing In")
	
	_Signing In_

1. In the **Common Settings** tab, notice that the dialog populates the drop down list labeled **Hosted Service** with the information for all the services configured in your Windows Azure account. Select the hosted service in this list where you wish to deploy the application.

1. Make sure the **Environment** is set to _Production_ and the **Build Configuration** to _Release_. Also, set the **Service Configuration** with _default_ value.
 
	![Deployment Common Settings](images/deployment-common-settings.png?raw=true "Deployment Common Settings")
	
	_Deployment Common Settings_

1. Click **Advanced Settings** tab. Update the **Deployment Label** to _MyTodo_ and check the check box labeled **Append date and time** to identify the deployment in the Developer Portal UI.

1. Like with the Hosted Services, the dialog populates the drop down list labeled **Storage account** with all the storage services that you have configured in your Windows Azure account. To publish a service, Visual Studio first uploads the service package to Azure storage, and then publish the service from there. Select the storage service that you wish to use for this purpose and click **Next**.
 
	![Deployment Advanced Settings](images/deployment-advanced-settings.png?raw=true "Deployment Advanced Settings")
	
	_Deployment Advanced Settings_

	>**Note:** Although this is not covered in this lab, the IntelliTrace option enables you to capture detailed trace logs of your running service in the cloud that you can download to your desktop to perform historical debugging. This can be invaluable when troubleshooting issues that occur during role start up. Note that IntelliTrace requires the .NET Framework 4 and it is only available in Visual Studio Ultimate edition.

1. Review the Summary information. If everything is OK, click **Publish** to start the deployment process.
 
	![Starting Deployment](images/start-deployment.png?raw=true "Starting Deployment")

	_Starting Deployment_

	>**Note:** At the top of the dialog, you will find a Target Profile drop down list. Once you configured your deployment settings, you can save them as a new profile and use it later without having to complete all the fields again.

1. If the slot that you chose is already occupied by a previous deployment, Visual Studio warns you and asks for confirmation before it replaces it. Click **Replace** if you are certain that the current deployment is no longer needed and can be overwritten. Otherwise, click **Cancel** and repeat the operation choosing a different deployment slot.

	![Overwriting an existing deployment](images/overwrite-existing-deployment.png?raw=true)
	
	_Overwriting an existing deployment_

1. After you start a deployment, you can examine the Windows Azure activity log window to determine the status of the operation. If this window is not visible, in the **View** menu, point to **Other Windows**, and then select **Windows Azure Activity Log**.

1. By default, the log shows a descriptive message and a progress bar to indicate the status of the deployment operation. 
 
	![Viewing summary information in the Windows Azure activity log](images/waz-activity-summary.png?raw=true "Viewing summary information in the Windows Azure activity log")
	
	_Viewing summary information in the Windows Azure activity log_

1. To view detailed information about the deployment operation in progress, double-click the green arrow on the left side of the activity log entry.
Notice that the additional information provided includes the deployment slot, **Production** or **Staging**, the **Website URL**, the **Deployment ID**, and a **History** log that shows state changes, including the time when each change occurred. 
 
	![Viewing detailed information about a deployment operation](images/detailed-deployment-information.png?raw=true "Viewing detailed information about a deployment operation")
	
	_Viewing detailed information about a deployment operation_

1. Wait for the deployment operation to complete, which may take several minutes. While this is happening, you can examine the **History** panel on the right side to determine the status of the deployment. For a successful deployment, it should resemble the following sequence.
 
	![Deployment operation history log](images/deployment-operation-log.png?raw=true "Deployment operation history log")
	
	_Deployment operation history log_

1. Once the deployment operation is complete, in the **Windows Azure Activity Log**, click the **Website URL** link for the completed operation to open the application in your browser and ensure that it is working properly. Notice the legend in the copyright notice at the bottom of the page indicating that this is the version that you deployed with Visual Studio.
 
	![Running the application deployed with Visual Studio](images/running-deployment.png?raw=true "Running the application deployed with Visual Studio")
	
	_Running the application deployed with Visual Studio_

<a name="Exercise4" />
### Exercise 4: Securing Windows Azure with SSL ###

In this exercise, you enable SSL to secure the myTODO application. This involves creating a self-signed certificate for server authentication and uploading it to the Windows Azure portal. With the certificate in place, you add a new HTTPS endpoint to the service model and assign the certificate to this endpoint.  You complete the exercise by deploying the application to Windows Azure one more time and then access it using its HTTPS endpoint.

<a name="Ex4Task1" />
#### Task 1 – Adding an HTTPS Endpoint to the Application ####

In this task, you update the service model of MyTODO to add an HTTPS endpoint and then you test the application in the compute emulator.

1. If not already open, launch Microsoft Visual Studio 2010 in elevated administrator mode. To do this, in **Start | All Programs | Microsoft Visual Studio 2010**, right-click the **Microsoft Visual Studio 2010** shortcut and choose **Run as administrator**. 

1. In the **File** menu, choose **Open** and then **Project/Solution**. In the **Open Project** dialog, browse to **Ex4-SecuringAppWithSSL\Begin** in the **Source** folder of the lab, select **MyTodo.sln** and click **Open**.

1. In **Solution Explorer**, expand the **Roles** node in the **MyTodo** project, and then double-click the **MyTodo.WebUx** role to open its properties window.

1. In the **MyTodo.WebUx \[Role\]** window, switch to the **Settings** tab and configure the necessary Azure Storage account details replacing [YOUR\_ACCOUNT\_NAME] with the name of your storage account and [YOUR\_ACCOUNT\_KEY] with the shared key. Do this for both _DataConnectionString_ and _Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString_ settings. These  are the same values that you used in previous exercises to configure the application. Remember to set the Type to Connection String for the both settings after leaving this screen.

1. Next, switch to the **Endpoints** tab and select the **HTTPS** option, fill Public Port with the value 443 and leave the **Name** field unchanged. Do not choose an SSL certificate at this time; you will do so later in the exercise.
 
	![Adding an HTTP endpoint to the application](images/adding-http-endpoint.png?raw=true "Adding an HTTP endpoint to the application")
	
	_Adding an HTTP endpoint to the application_

1. Now, choose the HTTPS endpoint as the one to use when you launch the application in the browser when you are debugging it. To do this, right-click the **MyTodo.WebUx** role in the **MyTodo** project, point to **Launch in Browser**, and then ensure that only **HTTPS** is selected.
 
	![Choosing the endpoint used to debug the application](images/choosing-debug-endpoint.png?raw=true "Choosing the endpoint used to debug the application")
	
	_Choosing the endpoint used to debug the application_

1. You will now test the application locally. Press **F5** to build and launch the application in the compute emulator. Notice that the browser indicates that there is a problem with the certificate. Ignore the warning and click **Continue to this website**.
 
	![Certificate error when testing in the compute emulator](images/certificate-error-computer-emulator.png?raw=true "Certificate error when testing in the compute emulator")
	
	_Certificate error when testing in the compute emulator_

	>**Note:** When testing your application in the local development environment using SSL, you do not need to configure a certificate. Instead, the compute emulator handles this requirement by using its own certificate. However, the certification authority for the certificate that it uses is not trusted, hence the warning. You may safely ignore the warning while you test your application locally.
	
	>If you wish, you can remove the warning by installing the certificate in the **Trusted Root Certification Authorities** certificate store. Note, however, that this has security implications that you need to evaluate before you proceed.
	
	>To remove the warning, open the **Microsoft Management Console**, add an instance of the **Certificates** snap-in and configure it to manage certificates for the **Computer** account. Expand the **Personal\Certificates** store and locate a certificate issued to 127.0.0.1. To ensure that you have the right certificate, view its properties to verify that the **Subject** and **Issuer** fields identify the certificate as belonging to the compute emulator. To trust the certificate, simply drag and drop the certificate from the **Personal** certificate store into the **Trusted Root Certification Authorities** certificate store.
	
	![Certificate used by the compute emulator to implement SSL](images/computer-emulator-certificate.png?raw=true "Certificate used by the compute emulator to implement SSL")

	_Certificate used by the compute emulator to implement SSL_

1. After you access the home page, notice that the address bar shows that you are now accessing the HTTPS endpoint.
 
	![Accessing the HTTPS endpoint in the compute emulator](images/accessing-endpoints.png?raw=true "Accessing the HTTPS endpoint in the compute emulator")

	_Accessing the HTTPS endpoint in the compute emulator_

1. Close the browser window. You will now create a self-signed certificate and deploy the application to Windows Azure.

1. Do not close the project in Visual Studio. You will need it shortly.

<a name="Ex4Task2" />
#### Task 2 – Creating a Self-Signed Certificate ####

In this task, you create a self-signed certificate that you can upload to the Windows Azure Developer Portal to configure an SSL endpoint for your application.

>**Note:** if you are unable to use Internet Information Services (IIS) Manager in your environment, you may skip this task. Instead, you can find a self-signed certificate that you can use among the lab’s resources.

>To install the certificate, open Windows Explorer, browse to **Assets** in the **Source** folder of the lab and then double-click the **YourNameToDo.pfx** file to install the certificate using the **Certificate Import Wizard**. Use "password1" (without the quotation marks) as the password. Use default values for all other options.

>**Important:** You should only use this certificate to complete the steps in the exercise. Do not use the certificate in your production deployments.


1. Start Internet Information Services Manager. To do this, click the **Start** button and type "iis" in the search box and then click **Internet Information Services (IIS) Manager** in the list of installed programs.
 
	![Launching Internet Information Services (IIS) Manager](images/iis-manager-launch.png?raw=true "Launching Internet Information Services \(IIS\) Manager")
	
	_Launching Internet Information Services (IIS) Manager_

1. In the **Connections** pane of the Internet Information Services (IIS) Manager console, select the top-level node corresponding to your computer. Next, locate the **IIS** category in the middle pane and double-click **Server Certificates**.
 
	![Managing certificates with Internet Information Services (IIS) Manager](images/iis-managing-certificates.png?raw=true "Managing certificates with Internet Information Services \(IIS\) Manager")

	_Managing certificates with Internet Information Services (IIS) Manager_

1. In the **Server Certificates** page, click **Create Self-Signed Certificate** in the **Actions** pane.
 
	![Creating a self-signed certificate in the Internet Information Services (IIS) Manager](images/iis-creating-self-signed-certificate.png?raw=true "Creating a self-signed certificate in the Internet Information Services \(IIS\) Manager")

	_Creating a self-signed certificate in the Internet Information Services (IIS) Manager_

1. In the **Specify Friendly Name** page of the **Create Self-Signed Certificate** wizard, enter a name to identify your certificate—this can be any name, for example, **\<yourname\>ToDo**, where you replace the placeholder with your name—and then click **OK**.
 
	![Specifying a name for the certificate](images/iis-specifying-certificate-name.png?raw=true "Specifying a name for the certificate")
	
	_Specifying a name for the certificate_

1. Now, right-click the newly created certificate and select **Export** to store the certificate in a file. 
 
	![Server certificates page showing the new self-signed certificate](images/iis-server-certificates.png?raw=true "Server certificates page showing the new self-signed certificate")
	
	_Server certificates page showing the new self-signed certificate_

1. In the **Export Certificate** dialog, enter the name of a file in which to store the certificate for exporting, type a password and confirm it, and then click **OK**. Make a record of the password. You will require it later on, when you upload the certificate to the portal.
 
	![Exporting the certificate to a file](images/iis-exporting-certificate.png?raw=true)
	
	_Exporting the certificate to a file_

<a name="Ex4Task3" />
#### Task 3 – Adding the Certificate to the Service Model of the Application ####

Previously, when you tested SSL access to the application in your local environment, you were able to do so without specifying a certificate by taking advantage of the certificate managed by the compute emulator. In this task, you configure the application to use the self-signed certificate that you created in Internet Information Services (ISS) Manager.

1. Switch back to Visual Studio. If you closed the project, you will need to reopen it from **Ex4-SecuringAppWithSSL\Begin** in the **Source** folder of the lab.

1. In **Solution Explorer**, expand the **Roles** node in the **MyTodo** project, double-click the **MyTodo.WebUx** role to open its properties window, and then switch to the **Certificates** tab.

1. In the **Certificates** page, click **Add Certificate**. Complete the **Name** field with a value that identifies the certificate that you are adding, for example, use _SSL_. Ensure that the **Store Location** is set to _LocalMachine_ and the **Store Name** is set to _My_ and then click the button labeled with an ellipsis, to the right of the **Thumbprint** column.

1. In the **Select a certificate** dialog, select the self-signed certificate that you created earlier and then click **OK**. 
	
	![Choosing a certificate for the service in Window Server 2008](images/selecting-certificate.png?raw=true "Choosing a certificate for the service in Window Server 2008")
	
	_Choosing a certificate for the service in Window Server 2008_

	![Choosing a certificate for the service in Windows 7](images/selecting-certificate-W7.png?raw=true "Choosing a certificate for the service in Windows 7")
 
	_Choosing a certificate for the service in Windows 7_

1. Notice that the dialog populates the **Thumbprint** column with the corresponding value from the certificate.  
 

	![Adding a certificate to the service model of the application](images/adding-certificate-service-model.png?raw=true "Adding a certificate to the service model of the application")
	
	_Adding a certificate to the service model of the application_

1. Now, switch to the **Endpoints** tab and, in the **HTTPS** input endpoints section, expand the **SSL certificate name** drop down list and select the certificate that you added to the service in the previous step.
 
	![Choosing a certificate to use for the HTTPS endpoint](images/choosing-certificate-https-endpoint.png?raw=true "Choosing a certificate to use for the HTTPS endpoint")
	
	_Choosing a certificate to use for the HTTPS endpoint_

1. Press **CTRL+S** to save the changes to the configuration.


<a name="Ex4Task4" />
#### Task 4 – Uploading the Certificate to the Windows Azure Management Portal ####

In this task, you upload the self-signed certificate created in the previous step to the Windows Azure Management Portal.

1. Navigate to [http://windows.azure.com](http://windows.azure.com) using a Web browser and sign in using your Windows Live ID.

1. Click in the **Hosted Services, Storage Accounts & CDN** link located on the lower left pane.
 
	![Creating a new hosted service](images/new-hosted-service-2.png?raw=true "Creating a new hosted service")
	
	_Creating a new hosted service_

1. Click in the **Hosted Services** node, located on the upper part of the left pane, and select **Certificates**, located under MyTodo Service.

1. Click in the **Add Certificate** button located on the ribbon.
 
	![Managing certificates in the Windows Azure Management Portal](images/managing-certificates-2.png?raw=true "Managing certificates in the Windows Azure Management Portal")
	
	_Managing certificates in the Windows Azure Management Portal_

1. In the **Upload an X.509 Certificate** popup, click **Browse**, and then navigate to the location where you stored the certificate exported in the previous task. Enter the password that specified when you exported the certificate, confirm it and then click **OK**.
 
	![Creating a certificate for the service](images/creating-certificate-service.png?raw=true "Creating a certificate for the service")
	
	_Creating a certificate for the service_

<a name="Ex4Verification" />
#### Verification ####

In this task, you deploy the application to Windows Azure and access its HTTPS endpoint to verify that your enabled SSL successfully.

1. Publish and deploy the application once again to the Windows Azure environment using your preferred method, by choosing among the Windows Azure Developer Portal, the Windows Azure Service Management PowerShell Cmdlets, or the Windows Azure Tools for Visual Studio. Refer to Exercises 1, 2, and 3 for instructions on how to carry out the deployment with any of these methods.

	>**Note:** The service configuration now specifies an additional endpoint for HTTPS, therefore, you cannot simply upgrade the current deployment and instead, you need to re-deploy the application. This is mandatory whenever you change the topology of the service.

1. Once you have deployed the application, start it and wait until its status is shown as **Ready** (or the deployment is shown as **Completed** when deploying with Visual Studio).

1. Now, browse to the HTTPS endpoint (e.g. _https://yournametodo.cloudapp.net_). Once again, you will observe a certificate error because the certificate authority for the self-signed certificate is not trusted. You may ignore this error.
 
	![Accessing the HTTPS endpoint in Windows Azure](images/accessing-https-endpoint.png?raw=true "Accessing the HTTPS endpoint in Windows Azure")
	
	_Accessing the HTTPS endpoint in Windows Azure_

	>**Note:** For your production deployments, you can purchase a certificate for your application from a trusted authority and use that instead.


<a name="Ex4Task5" />
#### Task 5 – Configuring a CNAME Entry for DNS Resolution (Optional) ####

When you deploy your application, the Windows Azure fabric assigns it a URL of the form _http://\[yournametodo\].cloudapp.net_, where [_yournametodo_] is the public name that you chose for your hosted service at the time of creation. While this URL is completely functional, there are many reasons why you might prefer to use a URL in your own domain to access the service. In other words, instead of accessing the application as _http://yournametodo.cloudapp.net_, use your own organization's domain name instead, for example _http://yournametodo.fabrikam.com_.

One way to map the application to your own domain is to set up a CNAME record in your own DNS system pointing at the host name in Azure. A CNAME provides an alias for any host record, including hosts in different domains. Thus, to map the application to the _fabrikam.com_ domain, you can create the following record in your DNS.

| **Organization's domain**     | **Alias**   | **Application's domain**       |
|---------------------------|---------|----------------------------|
| yournametodo.fabrikam.com | CNAME   | yournametodo.cloudapp.net  |


The procedure for doing this varies depending on the details of your DNS infrastructure. For external domain registrars, you can consult their documentation to find out the correct procedure for setting up a CNAME. For additional information on this topic, see [Custom Domain Names in Windows Azure](http://blog.smarx.com/posts/custom-domain-names-in-windows-azure).
As an example, this task briefly shows how you set up an alias using Microsoft DNS on Windows Server 2008. 

>**Note:** Windows DNS Server should be installed on the Windows Server 2008. You can enable the DNS Server role on the Server Manager.

1. Open DNS Manager from **Start | Administrative Tools | DNS**.

1. In DNS Manager, expand the **Forward Lookup Zones** node, then right-click the zone where you intend to set up the alias and select **New Alias (CNAME)**.Notice that if you do not have any zone, you must create one prior the alias creation.
 
	![Updating a lookup zone to create an alias](images/creating-alias.png?raw=true "Updating a lookup zone to create an alias")
	
	_Updating a lookup zone to create an alias_

1. In the **New Resource Record** dialog, enter the alias name that you would like to use to access the application hosted in Azure, for example, _yournametodo_. Then, type in the fully qualified domain name of your application that Azure assigned to your application, for example, _\[yournametodo\].cloudapp.net_. Click **OK** to create the record.
 
	![Creating an alias for the myTODO application in Azure](images/creating-alias-app.png?raw=true "Creating an alias for the myTODO application in Azure")
	
	_Creating an alias for the myTODO application in Azure_

1. In the DNS Manager console, review the contents of the updated zone to find the newly created CNAME record.
 
	![Updated lookup zone showing the new alias for the application](images/lookup-zone-alias.png?raw=true "Updated lookup zone showing the new alias for the application")
	
	_Updated lookup zone showing the new alias for the application_

1. Now, open a command prompt and type the following command to verify that the alias is set up correctly and maps to the address of the application in Windows Azure. 

	<!--mark: 1-->
	````CommandPrompt
	nslookup <youralias>
	````
 
	![Verifying the domain alias](images/command-prompt-alias-verification.png?raw=true "Verifying the domain alias")

	_Verifying the domain alias_
	

	You will now be able to access the application using the alias.

---

<a name="Summary" />
## Summary ##

By completing this hands-on lab, you learnt how to create a storage account and a hosted service at the Windows Azure Management Portal. Using the management portal, you deployed a service package that contained the application binaries, configured its storage and defined the number of instances to run. 

You also saw how to achieve this programmatically using the Service Management API and in particular, how to use the Windows Azure Service Management cmdlets to deploy, update, and manage applications using Windows PowerShell.

As a developer, you saw how to use Windows Azure Tools in Visual Studio to publish your solution in the background, while you continue with your development tasks.
Finally, you learnt how to upload certificates using the management portal and use SSL to secure your Windows Azure application.