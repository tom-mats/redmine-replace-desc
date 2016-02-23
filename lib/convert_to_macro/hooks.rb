module ConvertToMacro
  class Hooks < Redmine::Hook::Listener
    REGEXP_LIST = {
      "(\s|,)(f?pr\d+\w*)(\s|,)" => '\1{{fixfile(\2)}}\3',
      "vi?e?w:([A-Za-z0-9\._]+)" => '{{fixfile(\1)}}'
      }
    def controller_issues_new_before_save(context={})
      issue = context[:issue]
      p issue.description
      REGEXP_LIST.each do |k, v|
        issue.description.gsub!(/#{k}/, v)
      end
    end
    def controller_issues_edit_before_save(context={})
    end
  end
end