dotvim
======

Personal .vim directory (heavily inspired by https://github.com/bling/dotvim)

Based on https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

```
cd $HOME
mkdir $HOME/git
git clone --bare https://github.com/yt27/dotfiles.git $HOME/git/dotfiles.git
function config {
   /usr/bin/git --git-dir=$HOME/git/dotfiles.git --work-tree=$HOME $@
}
mkdir -p $HOME/.config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/.config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no
```
