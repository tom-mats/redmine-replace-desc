module ConvertToMacro
  class Hooks < Redmine::Hook::Listener
    REGEXP_LIST = {
      '(\A|\s|,)(f?pr\d+\w*)(\s|,|\Z)' => '\1{{fixfile(\2)}}\3',
      'vi?e?w:((?:\w|\.)+)' => '{{fixfile(\1)}}',
      '[^\(](\w\w\w?\w?-\d\d\d)[^\)]' => '{{alarm(' + "\\1".upcase + ')}}',
      '#(?:RB|rb|US|us)(\d+)[^\)]' => '{{usersupport(\1)}}',
      '[^\(](V\d\.\d\d(?:\d+|P\/(?:\d|\w)+))[^\)]' => '[[test:\1]]'
      }
    def controller_issues_new_before_save(context={})
      issue = context[:issue]
      REGEXP_LIST.each do |k, v|
        issue.description.gsub!(/#{k}/, v)
      end
    end
    def controller_issues_edit_before_save(context={})
      issue = context[:issue]
      REGEXP_LIST.each do |k, v|
        issue.description.gsub!(/#{k}/, v)
        issue.notes.gsub!(/#{k}/, v)
      end
    end
  end
end
