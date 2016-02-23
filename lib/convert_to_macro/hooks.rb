module ConvertToMacro
  class Hooks < Redmine::Hook::Listener
    REGEXP_LIST = {
      '(\A|\s|,)(f?pr\d+\w*)(\s|,|\Z)' => '\1{{fixfile(\2)}}\3',
      'vi?e?w:((?:\w|\.)+)' => '{{fixfile(\1)}}',
      '(\A|[^\(])(\w\w\w?\w?-\d\d\d)(\Z|[^\)])' => '\1{{alarm(' + "\\2".upcase + ')}}\3',
      '#(?:RB|rb|US|us)(\d+)' => '{{usersupport(\1)}}',
      '(\A|[^\(])(V\d\.\d\d(?:\d+|P\/(?:\d|\w)+))(\Z|[^\)])' => '\1[[test:\2]]\3'
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
