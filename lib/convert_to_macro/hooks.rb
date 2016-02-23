module ConvertToMacro
  class Hooks < Redmine::Hook::Listener
    REGEXP_LIST = {
      '(f?pr\d+\w*)' => '\1{{fixfile(\2)}}\3',
      'vi?e?w:((?:\w|\.)+)' => '\1{{fixfile(\2)}}\2',
      '(\w\w\w?\w?-\d\d\d)' => '\1{{alarm(' + "\\2".upcase + ')}}\3',
      '#(?:RB|rb|US|us)(\d+)' => '{{usersupport(\1)}}',
      '(V\d\.\d\d(?:\d+|P\/(?:\d|\w)+))' => '\1[[test:\2]]\3'
      }
    def controller_issues_new_before_save(context={})
      issue = context[:issue]
      REGEXP_LIST.each do |k, v|
        issue.description.gsub!(/(\A|[^\(])#{k}(\Z|[^\)])/, v)
      end
    end
    def controller_issues_edit_before_save(context={})
      issue = context[:issue]
      REGEXP_LIST.each do |k, v|
        issue.description.gsub!(/(\A|[^\(])#{k}(\Z|[^\)])/, v)
        issue.notes.gsub!(/(\A|[^\(])#{k}(\Z|[^\)])/, v)
      end
    end
  end
end
