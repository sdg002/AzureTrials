[[_TOC_]]

# About
??


---

# Copilot - How to install Argocd in an existing Kubernetes

Sure, I can help you with that! Here are the steps to install ArgoCD on your Azure Kubernetes Service (AKS) cluster:

1. **Set up your environment**:
   - Ensure you have the necessary command-line tools installed: `kubectl`, `argocd`, and optionally the Azure CLI.

2. **Create a namespace for ArgoCD**:
   ```sh
   kubectl create namespace argocd
   ```

3. **Install ArgoCD**:
   - Apply the ArgoCD installation manifest to your cluster:
   ```sh
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

4. **Access the ArgoCD UI**:
   - Forward the ArgoCD server port to your local machine:
   ```sh
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```
   - Open your browser and go to `http://localhost:8080`. The default username is `admin`, and you can get the initial password by running:
   ```sh
   kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
   ```

5. **Configure ArgoCD**:
   - Connect ArgoCD to your Git repository and set up your applications. You can do this through the ArgoCD UI by specifying the repository URL, path, and destination cluster/namespace.

For a more detailed guide, you can refer to [this tutorial](https://techcommunity.microsoft.com/t5/apps-on-azure-blog/getting-started-with-gitops-argo-and-azure-kubernetes-service/ba-p/3288595)⁴.

If you have any specific questions or run into issues, feel free to ask!

Source: Conversation with Copilot, 21/09/2024
(1) Getting started with GitOps, Argo, and Azure Kubernetes Service. https://techcommunity.microsoft.com/t5/apps-on-azure-blog/getting-started-with-gitops-argo-and-azure-kubernetes-service/ba-p/3288595.
(2) Install Argo CD on Kubernetes cluster | Deploy Application to Kubernetes using Argo CD | Helm Charts. https://www.youtube.com/watch?v=HzNszgkVuaA.
(3) ArgoCD Installation on Kubernetes : Step-by-Step Guide. https://www.youtube.com/watch?v=fBd_tz6BALU.
(4) ArgoCD Tutorial for Beginners | GitOps CD for Kubernetes. https://www.youtube.com/watch?v=MeU5_k9ssrs.
(5) How to Setup and Connect ArgoCD with AKS in 5 mins. https://kuberada-blog.readthedocs.io/blogs/k8s/argocd/argo.html.
(6) How to install ArgoCD on Kubernetes cluster - Omegion: Personal Blog. https://omegion.dev/2021/06/how-to-install-argocd-on-kubernetes-cluster/.
(7) Running Argo CD locally - Argo CD - Declarative GitOps CD for Kubernetes. https://argo-cd.readthedocs.io/en/stable/developer-guide/running-locally/.
(8) undefined. https://github.com/colossus06/Kuberada-Blog-Labs/tree/main/argocd.
(9) undefined. https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml.

