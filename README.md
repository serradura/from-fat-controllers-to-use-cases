# From **`fat controllers`** to _`use cases`_

Rails (API) app that shows different kinds of architecture (one per commit), and in the last one, how to use the Micro::Case gem to handle the application business logic.

## Instructions to run this application

* Ruby version: `2.6.5`
* System dependencies: [`sqlite3`](https://www.google.com/search?q=How+to+install+sqlite3&oq=How+to+install+sqlite3)
* Configuration and database creation: `bin/setup`
* How to run the test suite: `bin/rails test`

## The different kinds of architecture (project versions)

| Version | Description                                                                                                                                               | [Rubycritic](https://github.com/whitesmith/rubycritic) Score |
| ------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------- |
| 1       | [Fat controller](https://github.com/serradura/from-fat-controllers-to-use-cases/commit/99c0e34a6f064305975184d0c2a06b65fd7f52a0)                          | 91.53            |
| 2       | [Fat model, skinny controller](https://github.com/serradura/from-fat-controllers-to-use-cases/commit/10382990108f37017c1de9effe0184c2e0380dad)            | 87.45            |
| 3       | [Concerns](https://github.com/serradura/from-fat-controllers-to-use-cases/commit/55769be6dae4f2e4d312a8973622ad86babc54e3)                                | 89.25            |
| 4       | [Service objects](https://github.com/serradura/from-fat-controllers-to-use-cases/commit/0789d32007311334c00d9aff311add0f7e5304fa)                         | 92.55            |
| 4.1     | [Service objects - Inheritance](https://github.com/serradura/from-fat-controllers-to-use-cases/commit/97e8105fa464474b5dd590e067dc7ba388f3c5f8)           | 92.93            |
| 4.2     | [Service objects - Inheritance overusing](https://github.com/serradura/from-fat-controllers-to-use-cases/commit/17a90c28ea14e0131e6477c016c500701492a247) | 93.15            |
| 5       | [Interactors](https://github.com/serradura/from-fat-controllers-to-use-cases/commit/4cc47150115e8230da0daf76e96ef5ade7e02d0f)                             | 96.36            |
| 6       | [Domain objects](https://github.com/serradura/from-fat-controllers-to-use-cases/commit/556a52d5acc233f3898cdf14f8862d847fe24d4f)                          | 94.71            |
| 7       | [Use cases (Micro::Case)](https://github.com/serradura/from-fat-controllers-to-use-cases/commit/07cb885c6f2fb43504a1f200a2fe76771882fb2f)                 | 94.97            |
| 7.1     | [Use cases - Dryer version](https://github.com/serradura/from-fat-controllers-to-use-cases/commit/e6827057e46436bc394a96613017e7a01204e3a6)               | 95.24            |
| 7.2     | [Use cases- Improving the SRP](https://github.com/serradura/from-fat-controllers-to-use-cases/commit/50e763cdf57a9910f2e7fbe8021a89f679760247)            | 95.11            |

**Hint:** in any of the versions above, use `bin/rails rubycritic`  to see the full report result.

## Extra: How to list all the use cases?

Use the [`use_cases` task](https://github.com/serradura/from-fat-controllers-to-use-cases/commit/07cb885c6f2fb43504a1f200a2fe76771882fb2f#diff-b925c5c01b152f4f03ad8783f05f4bb4). e.g:

```sh
bin/rails use_cases

# Lines:
#     11 ./app/models/user/register/step/serialize_as_json.rb
#     12 ./app/models/user/register/step/validate_password.rb
#     17 ./app/models/user/register/step/create_record.rb
#     19 ./app/models/user/register/step/normalize_params.rb
#     10 ./app/models/user/register/flow.rb
#     18 ./app/models/todo/list/add_item.rb
#     16 ./app/models/todo/list/complete_item.rb
#     14 ./app/models/todo/list/delete_item.rb
#     12 ./app/models/todo/list/fetch_items.rb
#     14 ./app/models/todo/list/find_item.rb
#     19 ./app/models/todo/list/update_item.rb
#     16 ./app/models/todo/list/activate_item.rb
#     21 ./app/models/todo/serialize.rb
#    199 total
#
# Files: 13
```

**Note:** This task will only be available in the branches with use cases (`v7`, `v7.1`, `v7.2`).
