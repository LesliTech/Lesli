/*
Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
import app from "LesliVue/public"



app({
    data() {
        return {
            count: 0,
                data: [
                  {
                    id: 1,
                    first_name: 'Jesse',
                    last_name: 'Simmons',
                    date: '2016-10-15 13:43:27',
                    gender: 'Male'
                  },
                  {
                    id: 2,
                    first_name: 'John',
                    last_name: 'Jacobs',
                    date: '2016-12-15 06:00:53',
                    gender: 'Male'
                  },
                  {
                    id: 3,
                    first_name: 'Tina',
                    last_name: 'Gilbert',
                    date: '2016-04-26 06:26:28',
                    gender: 'Female'
                  },
                  {
                    id: 4,
                    first_name: 'Clarence',
                    last_name: 'Flores',
                    date: '2016-04-10 10:28:46',
                    gender: 'Male'
                  },
                  {
                    id: 5,
                    first_name: 'Anne',
                    last_name: 'Lee',
                    date: '2016-12-06 14:38:38',
                    gender: 'Female'
                  }
                ],
                columns: [
                  {
                    field: 'id',
                    label: 'ID',
                    width: '40',
                    numeric: true
                  },
                  {
                    field: 'first_name',
                    label: 'First Name'
                  },
                  {
                    field: 'last_name',
                    label: 'Last Name'
                  },
                  {
                    field: 'date',
                    label: 'Date',
                    position: 'centered'
                  },
                  {
                    field: 'gender',
                    label: 'Gender'
                  }
                ]
        }
    },
    mounted() {
        console.log("webpack & vue works")
    }
})
