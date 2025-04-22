#!/usr/bin/env zsh
# aws-instance-connect.plugin.zsh

SCRIPT_DIR=${0:A:h}
export SCRIPT_DIR
source $SCRIPT_DIR/_aws_instance_connect_get_instances

_aws_instance_connect_parse() {
  local FZF_DEFAULT_OPTS=(--layout "default")

  _aws_instance_connect_get_instances $@ |
    fzf --delimiter='\t' \
      --bind 'ctrl-i:execute-silent(echo -n {4} | pbcopy)+abort' \
      --bind 'ctrl-n:execute-silent(echo -n {2} | pbcopy)+abort' \
      --bind "ctrl-r:reload(source $SCRIPT_DIR/_aws_instance_connect_get_instances; _aws_instance_connect_get_instances $*)" \
      --bind="ctrl-/:toggle-preview" \
      --bind="enter:become(echo {1}; echo {2})" \
      --header-lines=1 \
      --with-nth=2,4,5,8,10 \
      "${AWS_INSTANCE_CONNECT_ZSH_FZF_OPTS[@]:-$FZF_DEFAULT_OPTS[@]}" \
      --preview='
          echo {} | awk -F"\t" "{
              print \"\033[2mIntance ID:\033[0m \"\$1
              print \"\033[2mName:\033[0m \"\$2
              print \"\033[2mPlatform:\033[0m \"\$3
              print \"\033[2mPrivate IP:\033[0m \"\$4
              print \"\033[2mState:\033[0m \"\$5
              print \"\033[2mKey name:\033[0m \"\$6
              print \"\033[2mAvailability Zone:\033[0m \"\$7
              print \"\033[2mType:\033[0m \"\$8
          }"
          echo
          echo "\033[2mSecurityGroups:\033[0m "; echo {9} | awk -F"," "{ for (i = 1; i <= NF; i++) print \"  \" \$i }"
          echo
          echo "\033[2mTags:\033[0m "; echo {10} | awk -F"," "{ for (i = 1; i <= NF; i++) print \"  \" \$i }"
      ' 
}

_aws_instance_connect_ssh(){
    _aws_instance_connect_parse $@ | {
      IFS= read -r instance_id
      IFS= read -r instance_name
    }
    if [[ ! -z "${instance_id}" ]]; then  
      echo "aws ec2-instance-connect ssh ${AWS_INSTANCE_CONNECT_ZSH_COMMAND_ARGS[@]} --instance-id ${instance_id}"  
      
      eval "$AWS_INSTANCE_CONNECT_ZSH_PRE_CMD" # [[ "${instance_name}" == "N/A" ]] && printf "\033]2;󰌘 ${instance_id}\007" || printf "\033]2;󰌘 ${instance_name}\007"
      aws ec2-instance-connect ssh ${AWS_INSTANCE_CONNECT_ZSH_COMMAND_ARGS[@]} --instance-id ${instance_id}
    fi
}

# Add filters if you have too many ec2 instances 
# alias eic='_aws_instance_connect_ssh Name=instance-state-name,Values=running'
# alias eic_dev='_aws_instance_connect_ssh Name=instance-state-name,Values=running Name=tag:Owner,Values=Team1'
# alias eic_team='_aws_instance_connect_ssh Name=tag:Owner,Values=Team1'
