# Udacity workspace terminal startup, loaded via --rcfile from
# .vscode/settings.json in place of ~/.bashrc.
[ -f ~/.bashrc ] && . ~/.bashrc

# Put dbt (and the venv's python) on PATH so learners can type `dbt build`.
export PATH="/opt/venv/bin:$PATH"

# Short prompt: just the current folder name.
PS1='\[\e[1;34m\]\W\[\e[0m\]\$ '
