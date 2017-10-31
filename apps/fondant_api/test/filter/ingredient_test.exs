defmodule Fondant.API.Filter.IngredientTest do
    use Fondant.Service.Case

    alias Fondant.API.Filter.Ingredient

    setup do
        aa = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "aa" })
        zz = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "zz" })
        aa_bb = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "aa", country: "BB" })
        _zz_bb = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "zz", country: "BB" })

        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Name.Model{ translate_id: 1, locale_id: aa.id, term: "foo_name_aa" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Name.Model{ translate_id: 1, locale_id: zz.id, term: "foo_name_zz" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Name.Model{ translate_id: 1, locale_id: aa_bb.id, term: "foo_name_aa_bb" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Name.Model{ translate_id: 2, locale_id: aa.id, term: "foobar_name_aa" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Name.Model{ translate_id: 2, locale_id: zz.id, term: "foobar_name_zz" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Name.Model{ translate_id: 2, locale_id: aa_bb.id, term: "foobar_name_aa_bb" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Name.Model{ translate_id: 3, locale_id: aa.id, term: "bar_name_aa" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Name.Model{ translate_id: 3, locale_id: zz.id, term: "bar_name_zz" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Name.Model{ translate_id: 3, locale_id: aa_bb.id, term: "bar_name_aa_bb" })

        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Type.Model{ translate_id: 1 + 3, locale_id: aa.id, term: "foo_type_aa" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Type.Model{ translate_id: 1 + 3, locale_id: zz.id, term: "foo_type_zz" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Type.Model{ translate_id: 1 + 3, locale_id: aa_bb.id, term: "foo_type_aa_bb" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Type.Model{ translate_id: 2 + 3, locale_id: aa.id, term: "foobar_type_aa" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Type.Model{ translate_id: 2 + 3, locale_id: zz.id, term: "foobar_type_zz" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Type.Model{ translate_id: 2 + 3, locale_id: aa_bb.id, term: "foobar_type_aa_bb" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Type.Model{ translate_id: 3 + 3, locale_id: aa.id, term: "bar_type_aa" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Type.Model{ translate_id: 3 + 3, locale_id: zz.id, term: "bar_type_zz" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Translation.Type.Model{ translate_id: 3 + 3, locale_id: aa_bb.id, term: "bar_type_aa_bb" })

        foo = Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Model{ name: 1, type: 1 + 3 })
        foobar = Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Model{ name: 2, type: 2 + 3 })
        bar = Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Ingredient.Model{ name: 3, type: 3 + 3 })

        {
            :ok,
            %{
                id: %{ foo: foo.id, foobar: foobar.id, bar: bar.id },
                data: %{
                    foo: %{
                        aa: %Fondant.Filter.Ingredient{ id: foo.id, name: "foo_name_aa", type: "foo_type_aa" },
                        zz: %Fondant.Filter.Ingredient{ id: foo.id, name: "foo_name_zz", type: "foo_type_zz" },
                        aa_bb: %Fondant.Filter.Ingredient{ id: foo.id, name: "foo_name_aa_bb", type: "foo_type_aa_bb" }
                    },
                    foobar: %{
                        aa: %Fondant.Filter.Ingredient{ id: foobar.id, name: "foobar_name_aa", type: "foobar_type_aa" },
                        zz: %Fondant.Filter.Ingredient{ id: foobar.id, name: "foobar_name_zz", type: "foobar_type_zz" },
                        aa_bb: %Fondant.Filter.Ingredient{ id: foobar.id, name: "foobar_name_aa_bb", type: "foobar_type_aa_bb" }
                    },
                    bar: %{
                        aa: %Fondant.Filter.Ingredient{ id: bar.id, name: "bar_name_aa", type: "bar_type_aa" },
                        zz: %Fondant.Filter.Ingredient{ id: bar.id, name: "bar_name_zz", type: "bar_type_zz" },
                        aa_bb: %Fondant.Filter.Ingredient{ id: bar.id, name: "bar_name_aa_bb", type: "bar_type_aa_bb" }
                    }
                }
            }
        }
    end

    test "retrieve queryables" do
        assert Enum.sort([:any, :name, :type]) == Enum.sort(Ingredient.queryables())
    end

    describe "get" do
        test "non-existent ingredient" do
            assert { :error, "Ingredient does not exist" } == Ingredient.get(0, "aa")
            assert { :error, "Ingredient does not exist" } == Ingredient.get(0, "zz")
            assert { :error, "Ingredient does not exist" } == Ingredient.get(0, "aa_BB")
        end

        test "non-existent locale" do
            assert { :error, "Invalid locale" } == Ingredient.get(0, "bb")
        end

        test "non-existent translation" do
            assert { :error, "Ingredient does not exist" } == Ingredient.get(0, "zz_BB")
        end

        test "existing ingredient", %{ id: %{ foo: foo_id, foobar: foobar_id, bar: bar_id }, data: ingredient } do
            assert { :ok, ingredient.foo.aa } == Ingredient.get(foo_id, "aa")
            assert { :ok, ingredient.foo.zz } == Ingredient.get(foo_id, "zz")
            assert { :ok, ingredient.foo.aa_bb } == Ingredient.get(foo_id, "aa_BB")

            assert { :ok, ingredient.foobar.aa } == Ingredient.get(foobar_id, "aa")
            assert { :ok, ingredient.foobar.zz } == Ingredient.get(foobar_id, "zz")
            assert { :ok, ingredient.foobar.aa_bb } == Ingredient.get(foobar_id, "aa_BB")

            assert { :ok, ingredient.bar.aa } == Ingredient.get(bar_id, "aa")
            assert { :ok, ingredient.bar.zz } == Ingredient.get(bar_id, "zz")
            assert { :ok, ingredient.bar.aa_bb } == Ingredient.get(bar_id, "aa_BB")
        end
    end

    describe "find" do
        test "non-existent locale" do
            assert { :error, "No locale provided" } == Ingredient.find([], [])
            assert { :error, "Invalid locale" } == Ingredient.find([], [locale: "bb"])
        end

        test "no queries", %{ id: %{ bar: bar_id }, data: ingredient } do
            assert { :ok, { results, page } } = Ingredient.find([], [locale: "aa", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                ingredient.foo.aa,
                ingredient.foobar.aa,
                ingredient.bar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([], [locale: "zz", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                ingredient.foo.zz,
                ingredient.foobar.zz,
                ingredient.bar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([], [locale: "aa_BB", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                ingredient.foo.aa,
                ingredient.foo.aa_bb,
                ingredient.foobar.aa,
                ingredient.foobar.aa_bb,
                ingredient.bar.aa,
                ingredient.bar.aa_bb
            ]) == Enum.sort(results)
        end

        test "pagination", %{ id: %{ foo: foo_id, foobar: foobar_id, bar: bar_id }, data: ingredient } do
            assert { :ok, { results, page } } = Ingredient.find([], [locale: "aa", limit: 1])
            assert foo_id == page
            assert [
                ingredient.foo.aa
            ] == results

            assert { :ok, { results, page } } = Ingredient.find([], [locale: "aa", limit: 1, page: page])
            assert foobar_id == page
            assert [
                ingredient.foobar.aa
            ] == results

            assert { :ok, { results, page } } = Ingredient.find([], [locale: "aa", limit: 1, page: page])
            assert bar_id == page
            assert [
                ingredient.bar.aa
            ] == results

            assert { :ok, { results, page } } = Ingredient.find([], [locale: "aa", limit: 1, page: page])
            assert bar_id == page
            assert [] == results
        end

        test "query name", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: ingredient } do
            assert { :ok, { results, page } } = Ingredient.find([name: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                ingredient.foo.aa,
                ingredient.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([name: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                ingredient.foo.zz,
                ingredient.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([name: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                ingredient.foo.aa,
                ingredient.foo.aa_bb,
                ingredient.foobar.aa,
                ingredient.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([name: "foo_name_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                ingredient.foo.aa
            ] == results

            assert { :ok, { results, page } } = Ingredient.find([name: "foo_name_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([name: "foo_name_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                ingredient.foo.aa,
                ingredient.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([name: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([name: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([name: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([name: "foo_type_a"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([name: "foo_type_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([name: "foo_type_a"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([name: "f", name: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([name: "f", name: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([name: "f", name: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "query type", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: ingredient } do
            assert { :ok, { results, page } } = Ingredient.find([type: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                ingredient.foo.aa,
                ingredient.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([type: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                ingredient.foo.zz,
                ingredient.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([type: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                ingredient.foo.aa,
                ingredient.foo.aa_bb,
                ingredient.foobar.aa,
                ingredient.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([type: "foo_type_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                ingredient.foo.aa
            ] == results

            assert { :ok, { results, page } } = Ingredient.find([type: "foo_type_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([type: "foo_type_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                ingredient.foo.aa,
                ingredient.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([type: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([type: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([type: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([type: "foo_name_a"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([type: "foo_name_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([type: "foo_name_a"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([type: "f", type: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([type: "f", type: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([type: "f", type: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "query any", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: ingredient } do
            assert { :ok, { results, page } } = Ingredient.find([any: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                ingredient.foo.aa,
                ingredient.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([any: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                ingredient.foo.zz,
                ingredient.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([any: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                ingredient.foo.aa,
                ingredient.foo.aa_bb,
                ingredient.foobar.aa,
                ingredient.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([any: "foo_name_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                ingredient.foo.aa
            ] == results

            assert { :ok, { results, page } } = Ingredient.find([any: "foo_name_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([any: "foo_name_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                ingredient.foo.aa,
                ingredient.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([any: "foo_type_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                ingredient.foo.aa
            ] == results

            assert { :ok, { results, page } } = Ingredient.find([any: "foo_type_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([any: "foo_type_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                ingredient.foo.aa,
                ingredient.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Ingredient.find([any: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([any: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([any: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([any: "f", any: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([any: "f", any: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([any: "f", any: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "all queries", %{ id: %{ foobar: foobar_id }, data: ingredient } do
            assert { :ok, { results, page } } = Ingredient.find([name: "f", type: "fo", any: "foob"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert [
                ingredient.foobar.aa
            ] == results

            assert { :ok, { results, page } } = Ingredient.find([name: "f", type: "fo", any: "bar"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([name: "f", type: "ba", any: "foob"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Ingredient.find([name: "b", type: "fo", any: "foob"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results
        end
    end
end
