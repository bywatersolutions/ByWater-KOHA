<template>
    <div id="package_list_result">
        <div id="filters">
            <a href="#" @click.prevent="toggle_filters($event)"
                ><i class="fa fa-search"></i>
                {{
                    display_filters ? $__("Hide filters") : $__("Show filters")
                }}
            </a>
            <fieldset v-if="display_filters" id="filters">
                <ol>
                    <li>
                        <label>{{ $__("Package name") }}:</label>
                        <input
                            type="text"
                            id="package_name_filter"
                            v-model="filters.package_name"
                            @keyup.enter="filter_table"
                        />
                    </li>
                    <li>
                        <label>{{ $__("Selection status") }}:</label>
                        <select
                            id="selection_type_filter"
                            v-model="filters.selection_type"
                        >
                            <option value="0">{{ $__("All") }}</option>
                            <option value="1">{{ $__("Selected") }}</option>
                            <option value="2">{{ $__("Not selected") }}</option>
                        </select>
                    </li>
                </ol>
                <input
                    @click="filter_table"
                    id="filter_table"
                    type="button"
                    :value="$__('Filter')"
                />
            </fieldset>
        </div>
        <table :id="table_id"></table>
    </div>
</template>

<script>
import { createVNode, render } from "vue"
import { useDataTable } from "../../composables/datatables"

export default {
    setup() {
        const table_id = "package_list"
        useDataTable(table_id)

        return {
            table_id,
        }
    },
    data() {
        return {
            filters: {
                package_name: "",
                selection_type: 0,
            },
            display_filters: false,
        }
    },
    methods: {
        show_resource: function (resource_id) {
            this.$router.push({
                name: "EHoldingsEBSCOResourcesShow",
                params: { resource_id },
            })
        },
        toggle_filters: function (e) {
            this.display_filters = !this.display_filters
        },
        filter_table: function () {
            $("#" + this.table_id)
                .DataTable()
                .draw()
        },
        build_datatable: function () {
            let show_resource = this.show_resource
            let resources = this.resources
            let filters = this.filters
            let table_id = this.table_id
            let router = this.$router

            $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(
                search => search.name != "apply_filter"
            )
            $("#" + table_id).dataTable({
                ...dataTablesDefaults,
                ...{
                    data: resources,
                    embed: ["package.name"],
                    ordering: false,
                    dom: '<"top pager"<"table_entries"ilp>>tr<"bottom pager"ip>',
                    lengthMenu: [
                        [10, 20, 50, 100],
                        [10, 20, 50, 100],
                    ],
                    autoWidth: false,
                    columns: [
                        {
                            title: __("Name"),
                            data: "package.name",
                            searchable: false,
                            orderable: false,
                            render: function (data, type, row, meta) {
                                // Rendering done in drawCallback
                                return ""
                            },
                            width: "100%",
                        },
                    ],
                    drawCallback: function (settings) {
                        var api = new $.fn.dataTable.Api(settings)

                        if (!api.rows({ search: "applied" }).count()) return

                        $.each(
                            $(this).find("tbody tr td:first-child"),
                            function (index, e) {
                                let tr = $(this).parent()
                                let row = api.row(tr).data()
                                if (!row) return // Happen if the table is empty
                                let { href } = router.resolve({
                                    name: "EHoldingsEBSCOResourcesShow",
                                    params: { resource_id: row.resource_id },
                                })
                                let n = createVNode(
                                    "a",
                                    {
                                        role: "button",
                                        href,
                                        onClick: e => {
                                            e.preventDefault()
                                            show_resource(row.resource_id)
                                        },
                                    },
                                    `${row.package.name}`
                                )
                                if (row.is_selected) {
                                    n = createVNode("span", {}, [
                                        n,
                                        " ",
                                        createVNode("i", {
                                            class: "fa fa-check-square",
                                            style: {
                                                color: "green",
                                                float: "right",
                                            },
                                            title: __("Is selected"),
                                        }),
                                    ])
                                }
                                render(n, e)
                            }
                        )
                    },
                    initComplete: function () {
                        $.fn.dataTable.ext.search.push(function apply_filter(
                            settings,
                            data,
                            dataIndex,
                            row
                        ) {
                            return (
                                row.package.name.match(
                                    new RegExp(filters.package_name, "i")
                                ) &&
                                (filters.selection_type == 0 ||
                                    (filters.selection_type == 1 &&
                                        row.is_selected) ||
                                    (filters.selection_type == 2 &&
                                        !row.is_selected))
                            )
                        })
                    },
                },
            })
        },
    },
    mounted() {
        this.build_datatable()
    },
    props: {
        resources: Array,
    },
    name: "EHoldingsEBSCOTitlePackagesList",
}
</script>

<style scoped>
#package_list {
    display: table;
}
#filters fieldset {
    margin: 0;
}
</style>
