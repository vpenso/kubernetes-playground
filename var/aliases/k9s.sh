command -v k9s >/dev/null && {
        config=${XDG_CONFIG_HOME:-~/.config}/k9s
        k9s_path=$KUBERNETES_PLAYGROUND_PATH/etc/k9s
        test -d $config/skins || mkdir -vp $config/skins
        test -L $config/config.yaml \
		|| ln -v -fs $k9s_path/config.yaml $config/config.yaml
	skin_url=https://raw.githubusercontent.com/derailed/k9s/refs/heads/master/skins/in-the-navy.yaml
        test -f $config/skins/in-the-navy.yaml \
		|| curl -s $skin_url -o $config/skins/in-the-navy.yaml
}
