.PHONY: diff-k3d
diff-k3d:
	flux diff --verbose kustomization --path=./clusters/local flux-system -n flux-system
